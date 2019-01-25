//
//  BluetoothManager.swift
//  rx7
//
//  Created by Austin Barnes on 4/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import CoreBluetooth
import Bond

typealias BluetoothDataReceivedClosure = (Data?) -> Void

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

class BluetoothManager: NSObject {
    
    static let singleton = BluetoothManager()
    
    fileprivate var centralManager: CBCentralManager!
    fileprivate var connectedPeripheral: CBPeripheral?
    fileprivate var characteristicMap = [CBUUID: CBCharacteristic]()
    fileprivate var listeners = [BluetoothConfig.Characteristics: [BluetoothDataReceivedClosure]]()
    fileprivate var readRequestCallbacks = [BluetoothConfig.Characteristics: [BluetoothDataReceivedClosure]]()
    fileprivate var writeWithResponseRequestCallbacks = [BluetoothConfig.Characteristics: [BluetoothDataReceivedClosure]]()
    private(set) var state = Observable<BluetoothState>(.unknown)
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func write(data: Data?, forCharacteristic characteristic: BluetoothConfig.Characteristics, _ responseHandler: @escaping BluetoothDataReceivedClosure) {
        guard let _ = characteristicMap[characteristic.asCBUUID] else { return }
        if (writeWithResponseRequestCallbacks[characteristic] == nil) {
            writeWithResponseRequestCallbacks[characteristic] = [responseHandler]
        } else {
            writeWithResponseRequestCallbacks[characteristic]?.append(responseHandler)
        }
        write(data: data, forCharacteristic: characteristic, withResponse: true)
    }
    
    func write(data: Data?, forCharacteristic characteristic: BluetoothConfig.Characteristics, withResponse: Bool = false) {
        guard let peripheral = connectedPeripheral, let cbCharacteristic = characteristicMap[characteristic.asCBUUID] else { return }
        let writeType = withResponse ? CBCharacteristicWriteType.withResponse : CBCharacteristicWriteType.withoutResponse
        let writtenData = (data == nil) ? Data() : data!
        peripheral.writeValue(writtenData, for: cbCharacteristic, type: writeType)
        
        print("Attempted to write data for characteristic \(cbCharacteristic)")
    }
    
    func read(characteristic: BluetoothConfig.Characteristics, _ closure: @escaping BluetoothDataReceivedClosure) {
        guard let readingCharacteristic = characteristicMap[characteristic.asCBUUID] else { return }
        if (readRequestCallbacks[characteristic] == nil) {
            readRequestCallbacks[characteristic] = [closure]
        } else {
            readRequestCallbacks[characteristic]?.append(closure)
        }
        connectedPeripheral?.readValue(for: readingCharacteristic)
    }
    
    func subscribe(to characteristic: BluetoothConfig.Characteristics, _ closure: @escaping BluetoothDataReceivedClosure) {
        if let _ = listeners[characteristic] {
            listeners[characteristic]?.append(closure)
        } else {
            listeners[characteristic] = [closure]
        }
    }
    
    func shutdown() {
        write(data: nil, forCharacteristic: BluetoothConfig.Characteristics.shutdown)
    }
    
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("BluetoothManager: central.state is .unknown")
        case .resetting:
            print(" BluetoothManager:central.state is .resetting")
        case .unsupported:
            print(" BluetoothManager:central.state is .unsupported")
        case .unauthorized:
            print("BluetoothManager: central.state is .unauthorized")
        case .poweredOff:
            print("BluetoothManager: central.state is .poweredOff")
        case .poweredOn:
            print("BluetoothManager: central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [BluetoothConfig.Services.service])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("BluetoothManager: peripheral found: \(peripheral)")
        
        state.next(.connecting)
        
        connectedPeripheral = peripheral
        if let connectedPeripheral = connectedPeripheral {
            connectedPeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(connectedPeripheral)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("BluetoothManager: Connected!")
        connectedPeripheral?.discoverServices([BluetoothConfig.Services.service])
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("BluetoothManager: didDiscoverService \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        state.next(.connected)
        
        for characteristic in characteristics {
            print("BluetoothManager: didDiscoverCharacteristicsFor \(characteristic)")

            characteristicMap[characteristic.uuid] = characteristic
            
            if characteristic.properties.contains(.notify) {
                print("BlueteoothManager: \(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case BluetoothConfig.Characteristics.deviceLoad.asCBUUID:
            handleUpdate(for: BluetoothConfig.Characteristics.deviceLoad, withValue: characteristic.value)
        case BluetoothConfig.Characteristics.engineData.asCBUUID:
            handleUpdate(for: BluetoothConfig.Characteristics.engineData, withValue: characteristic.value)
        case BluetoothConfig.Characteristics.gpsReceiver.asCBUUID:
            handleUpdate(for: BluetoothConfig.Characteristics.gpsReceiver, withValue: characteristic.value)
        case BluetoothConfig.Characteristics.thresholdConfig.asCBUUID:
            handleUpdate(for: BluetoothConfig.Characteristics.thresholdConfig, withValue: characteristic.value)
        default:
            print("BluetoothManager: Unhandled value update for Bluetooth Characteristic with UUID: \(characteristic.uuid)")
        }
    }
    
    private func handleUpdate(for characteristic: BluetoothConfig.Characteristics, withValue value: Data?) {
        print("BluetoothManager: handling update for characteristic \(characteristic)")
        if let notifyCallbacks = listeners[characteristic] {
            for callback in notifyCallbacks {
                callback(value)
            }
        }
        
        if let readCallbacks = readRequestCallbacks[characteristic] {
            for callback in readCallbacks {
                callback(value)
            }
            readRequestCallbacks[characteristic] = nil
        }
        
        if let writeCallbacks = writeWithResponseRequestCallbacks[characteristic] {
            if (writeCallbacks.count > 0) {
                writeCallbacks[0](value)
                writeWithResponseRequestCallbacks[characteristic]!.removeFirst(1)
            }
        }
    }
    
}
