//
//  BluetoothCentralManager.swift
//  rx7
//
//  Created by Austin Barnes on 3/4/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import BlueCapKit
import CoreBluetooth

enum BluetoothError: Error {
    case dataCharactertisticNotFound
    case enabledCharactertisticNotFound
    case updateCharactertisticNotFound
    case serviceNotFound
    case invalidState
    case resetting
    case poweredOff
    case unknown
    case unlikley
}

protocol BluetoothCentralManagerDelegate: class {
    func dataUpdateReceived(data: Data)
}

class BluetoothCentralManager {
    
    static let singleton = BluetoothCentralManager()
    
    private let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "us.gnos.BlueCap.central-manager-example" as NSString])
    private var dataCharacteristic : Characteristic?
    weak var delegate: BluetoothCentralManagerDelegate?
    
    init() {
        setupBluetooth()
    }
    
    private func setupBluetooth() {
        let serviceUUID = CBUUID(string: BluetoothConfig.Services.service)
        var peripheral: Peripheral?
        //let dateCharacteristicUUID = CBUUID(string:"ec0e")
        let dateCharacteristicUUID = CBUUID(string: BluetoothConfig.Characteristics.engineData)
        
        //initialize a central manager with a restore key. The restore key allows to resuse the same central manager in future calls
        let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
        
        //A future stram that notifies us when the state of the central manager changes
        let stateChangeFuture = manager.whenStateChanges()
        
        //handle state changes and return a scan future if the bluetooth is powered on.
        let scanFuture = stateChangeFuture.flatMap { state -> FutureStream<Peripheral> in
            switch state {
            case .poweredOn:
                print("powered on")
                //scan for peripherlas that advertise the ec00 service
                return manager.startScanning(forServiceUUIDs: [serviceUUID])
            case .poweredOff:
                throw BluetoothError.poweredOff
            case .unauthorized, .unsupported:
                throw BluetoothError.invalidState
            case .resetting:
                throw BluetoothError.resetting
            case .unknown:
                //generally this state is ignored
                throw BluetoothError.unknown
            }
        }
        
        scanFuture.onFailure { error in
            guard let bluetoothError = error as? BluetoothError else {
                return
            }
            
            switch bluetoothError {
            case .invalidState:
                break
            case .resetting:
                manager.reset()
            case .poweredOff:
                break
            case .unknown:
                break
            default:
                break;
            }
        }
        
        //We will connect to the first scanned peripheral
        let connectionFuture = scanFuture.flatMap { p -> FutureStream<Void> in
            //stop the scan as soon as we find the first peripheral
            //manager.stopScanning()
            peripheral = p
            guard let peripheral = peripheral else {
                throw BluetoothError.unknown
            }
            
            print("Found peripheral \(peripheral.identifier.uuidString). Trying to connect")
            
            //connect to the peripheral in order to trigger the connected mode
            return peripheral.connect()
        }
        
        //we will next discover the "ec00" service in order be able to access its characteristics
        let discoveryFuture = connectionFuture.flatMap { _ -> Future<Void> in
            guard let peripheral = peripheral else {
                throw BluetoothError.unknown
            }
            manager.stopScanning()
            return peripheral.discoverServices([serviceUUID])
            }.flatMap { _ -> Future<Void> in
                guard let discoveredPeripheral = peripheral else {
                    throw BluetoothError.unknown
                }
                guard let service = discoveredPeripheral.services(withUUID:serviceUUID)?.first else {
                    throw BluetoothError.serviceNotFound
                }
                peripheral = discoveredPeripheral
                
                print("Discovered service \(service.uuid.uuidString). Trying to discover characteristics")
                
                //we have discovered the service, the next step is to discover the "ec0e" characteristic
                return service.discoverCharacteristics([dateCharacteristicUUID])
        }
        
        /**
         1- checks if the characteristic is correctly discovered
         2- Register for notifications using the dataFuture variable
         */
        let dataFuture = discoveryFuture.flatMap { _ -> Future<Void> in
            guard let discoveredPeripheral = peripheral else {
                throw BluetoothError.unknown
            }
            guard let dataCharacteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                throw BluetoothError.dataCharactertisticNotFound
            }
            self.dataCharacteristic = dataCharacteristic
            
            print("Discovered characteristic \(dataCharacteristic.uuid.uuidString).")
            
            //read the data from the characteristic
            //self.read()
            
            //Ask the characteristic to start notifying for value change
            return dataCharacteristic.startNotifying()
            }.flatMap { _ -> FutureStream<Data?> in
                guard let discoveredPeripheral = peripheral else {
                    throw BluetoothError.unknown
                }
                guard let characteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicUUID)?.first else {
                    throw BluetoothError.dataCharactertisticNotFound
                }
                //regeister to recieve a notifcation when the value of the characteristic changes and return a future that handles these notifications
                return characteristic.receiveNotificationUpdates()
        }
        

        
        var time = 0
        var count = 0
        var responseCount = 0
        
        //The onSuccess method is called every time the characteristic value changes
        dataFuture.onSuccess { [weak self] data in
            responseCount += 1
            let date = Int(Date().timeIntervalSince1970)
            
            if (date > time) {
                print("-----------------------")
                print("\(count)Bps at \(responseCount)")
                print("-----------------------")
                time = date
                count = 0
            }
            
            guard let data = data else { return }
            count += data.count
            
            let dataPoint = BasicEngineData(fromData: data)
            print(dataPoint)
            
            self?.delegate?.dataUpdateReceived(data: data)
        }
        
        //handle any failure in the previous chain
        dataFuture.onFailure { error in
            switch error {
            case PeripheralError.disconnected:
                peripheral?.reconnect()
            case BluetoothError.serviceNotFound:
                break
            case BluetoothError.dataCharactertisticNotFound:
                break
            default:
                break
            }
        }
    }
    
    /*
    func read(){
        //read a value from the characteristic
        let readFuture = self.dataCharacteristic?.read(timeout: 5)
        readFuture?.onSuccess { (_) in
            //the value is in the dataValue property
            let s = String(data:(self.dataCharacteristic?.dataValue)!, encoding: .utf8)
            print("Read value is \(String(describing: s))")
        }
        readFuture?.onFailure { (_) in
            print("read error")
        }
    }
    
    func write(){
        //write a value to the characteristic
        let writeFuture = self.dataCharacteristic?.write(data: "text".data(using: .utf8)!)
        writeFuture?.onSuccess(completion: { (_) in
            print("write success")
        })
        writeFuture?.onFailure(completion: { (e) in
            print("write failed")
        })
    }
 */
    
}
