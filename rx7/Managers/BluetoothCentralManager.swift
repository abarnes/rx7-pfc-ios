//
//  BluetoothCentralManager.swift
//  rx7
//
//  Created by Austin Barnes on 3/4/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import BlueCapKit
import CoreBluetooth
import Bond

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

enum BluetoothState: String {
    case unknown = "Unknown"
    case poweredOff = "Powered Off"
    case poweredOn = "Powered On"
    case searching = "Searching"
    case connecting = "Connecting"
    case connected = "Connected"
    case active = "Active"
    case stalled = "Stalled"
}

protocol BluetoothCentralManagerDelegate: class {
    func dataUpdateReceived(data: Data, forCharacteristic characteristic: BluetoothConfig.Characteristics)
}

class BluetoothCentralManager {
    
    /// MARK - Properties
    
    static let singleton = BluetoothCentralManager()
    
    private let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "us.gnos.BlueCap.central-manager-example" as NSString])
    private var connectedCharacteristics = [BluetoothConfig.Characteristics: Characteristic]()
    private(set) var state = Observable<BluetoothState>(.unknown)
    weak var delegate: BluetoothCentralManagerDelegate?

    /// MARK - Constructors
    
    init() {
        setupBluetooth()
    }
    
    /// MARK - Public Methods
    
    func read(characteristic: BluetoothConfig.Characteristics){
        guard let foundCharacteristic = connectedCharacteristics[characteristic] else {
            print("Characteristic is not connected! \(characteristic.rawValue)")
            return
        }
        
        //read a value from the characteristic
        let readFuture = foundCharacteristic.read(timeout: 5)
        readFuture.onSuccess { (_) in
            //the value is in the dataValue property
            guard let value = foundCharacteristic.dataValue else { return }
            let s = String(data: value, encoding: .utf8)
            print("Read value is \(String(describing: s)) for characteristic \(characteristic.rawValue)")
        }
        readFuture.onFailure { (_) in
            print("Error reading characteristic \(characteristic.rawValue)")
        }
    }
    
    func write(_ data: Data, forCharacteristic characteristic: BluetoothConfig.Characteristics) {
        guard let foundCharacteristic = connectedCharacteristics[characteristic], foundCharacteristic.canWrite else {
            print("Characteristic is not connected/not writeable! \(characteristic.rawValue)")
            return
        }
        
        let writeFuture = foundCharacteristic.write(data: data, timeout: TimeInterval.infinity, type: CBCharacteristicWriteType.withoutResponse)
        writeFuture.onSuccess(completion: { (_) in
            print("write success")
        })
        writeFuture.onFailure(completion: { (e) in
            print("write failed with error \(e)")
        })
    }
    
    /// MARK - Private Methods
    
    private func setupBluetooth() {
        let serviceUUID = BluetoothConfig.Services.service
        var peripheral: Peripheral?
        //let dateCharacteristicUUID = CBUUID(string:"ec0e")
        let dateCharacteristicUUID = CBUUID(string: BluetoothConfig.Characteristics.engineData.rawValue)
        
        //initialize a central manager with a restore key. The restore key allows to resuse the same central manager in future calls
        let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
        
        //A future stram that notifies us when the state of the central manager changes
        let stateChangeFuture = manager.whenStateChanges()
        
        //handle state changes and return a scan future if the bluetooth is powered on.
        let scanFuture = stateChangeFuture.flatMap { [weak self] internalState -> FutureStream<Peripheral> in
            switch internalState {
            case .poweredOn:
                self?.state.next(.poweredOn)
                print("powered on")
                
                //scan for peripherals that advertise the ec00 service
                self?.state.next(.searching)
                return manager.startScanning(forServiceUUIDs: [serviceUUID])
            case .poweredOff:
                self?.state.next(.poweredOff)
                throw BluetoothError.poweredOff
            case .unauthorized, .unsupported:
                self?.state.next(.unknown)
                throw BluetoothError.invalidState
            case .resetting:
                throw BluetoothError.resetting
            case .unknown:
                self?.state.next(.unknown)
                //generally this state is ignored
                throw BluetoothError.unknown
            }
        }
        
        scanFuture.onFailure { [weak self] error in
            guard let bluetoothError = error as? BluetoothError else {
                return
            }
            
            switch bluetoothError {
            case .invalidState:
                self?.state.next(.unknown)
                break
            case .resetting:
                self?.state.next(.unknown)
                manager.reset()
            case .poweredOff:
                self?.state.next(.poweredOff)
                break
            case .unknown:
                self?.state.next(.unknown)
                break
            default:
                break;
            }
        }
        
        //We will connect to the first scanned peripheral
        let connectionFuture = scanFuture.flatMap { [weak self] foundPeripheral -> FutureStream<Void> in
            peripheral = foundPeripheral
            guard let peripheral = peripheral else {
                throw BluetoothError.unknown
            }
            
            //stop the scan as soon as we find the first peripheral
            manager.stopScanning()
            self?.state.next(.connecting)
            
            print("Found peripheral \(peripheral.identifier.uuidString). Trying to connect")
            
            //connect to the peripheral in order to trigger the connected mode
            return peripheral.connect()
        }
        
        //we will next discover the "ec00" service in order be able to access its characteristics
        let discoveryFuture = connectionFuture.flatMap { _ -> Future<Void> in
            guard let peripheral = peripheral else {
                throw BluetoothError.unknown
            }
            
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
        

        for characteristic in BluetoothConfig.enabledCharacteristics {
            
            let dataFuture = discoveryFuture.flatMap { [weak self] _ -> Future<Void> in
                guard let `self` = self, let discoveredPeripheral = peripheral else {
                    throw BluetoothError.unknown
                }
                
                guard let discoveredService = discoveredPeripheral.services(withUUID:serviceUUID)?.first else {
                    throw BluetoothError.dataCharactertisticNotFound
                }
                
                // print("Discovered characteristic \(characteristic.rawValue).")
                guard let foundCharacteristic = discoveredService.characteristics(withUUID: dateCharacteristicUUID)?.first else {
                    throw BluetoothError.dataCharactertisticNotFound
                }
                
                self.connectedCharacteristics[characteristic] = foundCharacteristic
                if (characteristic.shouldReceiveNotifications) {
                    return foundCharacteristic.startNotifying()
                }
                
                return Future()
            }.flatMap { _ -> FutureStream<Data?> in
                guard let discoveredPeripheral = peripheral else {
                    throw BluetoothError.unknown
                }
                guard let foundCharacteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID: CBUUID(string: characteristic.rawValue))?.first else {
                    throw BluetoothError.dataCharactertisticNotFound
                }
                
                print("Discovered characteristic \(characteristic.rawValue).")
                
                //regeister to recieve a notifcation when the value of the characteristic changes and return a future that handles these notifications
                return foundCharacteristic.receiveNotificationUpdates()
            }
            
            dataFuture.onSuccess(completion: { [weak self] data in
                // handle data
                guard let data = data else { return }
                self?.handleDataUpdate(data)
            })
            
            dataFuture.onFailure(completion: { [weak self] (error) in
                //self?.handleError(error)
            })
        }
    }
    
    /// Private Methids
    
    var time = 0
    var count = 0
    var responseCount = 0
    
    private func handleDataUpdate(_ data: Data) {
        // test code---------------------------------------
        responseCount += 1
        let date = Int(Date().timeIntervalSince1970)
        
        if (date > time) {
            print("-----------------------")
            print("\(count)Bps at \(responseCount)")
            print("-----------------------")
            time = date
            count = 0
        }
        count += data.count
        // end test code---------------------------------------
        
        if (state.value != .active) {
            state.next(.active)
        }
        
        // identify command
        delegate?.dataUpdateReceived(data: data, forCharacteristic: BluetoothConfig.Characteristics.engineData) // stop hard coding this
    }
    
    private func handleError(_ error: BluetoothError) {
        /*
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
         */
    }
    
}
