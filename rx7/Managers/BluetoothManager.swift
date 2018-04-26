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
    fileprivate var listeners = [BluetoothConfig.Characteristics: [BluetoothDataReceivedClosure]]()
    private(set) var state = Observable<BluetoothState>(.unknown)
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func write(data: Data, forCharacteristic characteristic: CBCharacteristic, withResponse: Bool = false) {
        guard let peripheral = connectedPeripheral else { return }
        let writeType = withResponse ? CBCharacteristicWriteType.withResponse : CBCharacteristicWriteType.withoutResponse
        peripheral.writeValue(data, for: characteristic, type: writeType)
    }
    
    func read(characteristic: BluetoothConfig.Characteristics, _ closure: @escaping BluetoothDataReceivedClosure) {

    }
    
    func subscribe(to characteristic: BluetoothConfig.Characteristics, _ closure: @escaping BluetoothDataReceivedClosure) {
        if let _ = listeners[characteristic] {
            listeners[characteristic]?.append(closure)
        } else {
            listeners[characteristic] = [closure]
        }
    }
    
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("BluteoothManager: central.state is .unknown")
        case .resetting:
            print(" BluteoothManager:central.state is .resetting")
        case .unsupported:
            print(" BluteoothManager:central.state is .unsupported")
        case .unauthorized:
            print("BluteoothManager: central.state is .unauthorized")
        case .poweredOff:
            print("BluteoothManager: central.state is .poweredOff")
        case .poweredOn:
            print("BluteoothManager: central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [BluetoothConfig.Services.service])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("BluteoothManager: peripheral found: \(peripheral)")
        
        connectedPeripheral = peripheral
        if let connectedPeripheral = connectedPeripheral {
            connectedPeripheral.delegate = self
            centralManager.stopScan()
            centralManager.connect(connectedPeripheral)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("BluteoothManager: Connected!")
        connectedPeripheral?.discoverServices([BluetoothConfig.Services.service])
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("BluteoothManager: didDiscoverService \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("BluteoothManager: didDiscoverCharacteristicsFor \(characteristic)")

            if characteristic.properties.contains(.read) {
                print("BluteoothManager: \(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("BluteoothManager: \(characteristic.uuid): properties contains .notify")
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
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    private func handleUpdate(for characteristic: BluetoothConfig.Characteristics, withValue value: Data?) {
        print("BluetoothManager: handling update for characteristic \(characteristic)")
        guard let callbacks = listeners[characteristic] else { return }
        for callback in callbacks {
            callback(value)
        }
    }
    
}
