//
//  GaugeConfigManager.swift
//  rx7
//
//  Created by Austin Barnes on 10/12/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

class GaugeConfigManager {

    static let singleton = GaugeConfigManager()
    
    struct Constants {
        static let readGaugeConfigStartingByte = UInt8(0)
        static let setGaugeConfigStartingByte = UInt8(1)
    }
    
    private let bluetoothManager = BluetoothManager.singleton
    
    func readGauges(_ completionHandler: @escaping ([EngineDataItem], [EngineDataItem]) -> Void) {
        // TODO replace this with what's read over bluetooth
        let gauges: [EngineDataItem] = [.rpm, .boost, .injectorDuty, .batteryVoltage, .knock]
        let monitors: [EngineDataItem] = [.electricalLoadSwitch, .waterTemp, .intakeTemp]
        completionHandler(gauges, monitors)
    }
    
    func setGauges(gauges: [EngineDataItem], monitors: [EngineDataItem], _ completionHandler: ((Bool) -> Void)?) {
        let rawData = constructData(gauges: gauges, monitors: monitors)
        
        bluetoothManager.write(data: rawData, forCharacteristic: BluetoothConfig.Characteristics.layoutConfig, withResponse: false)
        
        // TODO revise this to work
        DispatchQueue.global().after(when: 10) {
            completionHandler?(true)
        }
        
    }
    
    /// MARK - Private
    
    private func constructData(gauges: [EngineDataItem], monitors: [EngineDataItem]) -> Data {
        var dataArray = Data(count: 0)
        
        dataArray.append(contentsOf: [Constants.setGaugeConfigStartingByte])
        
        for gauge in gauges {
            dataArray.append(contentsOf: [UInt8(gauge.rawValue), 1, 30])
        }
        
        dataArray.append(contentsOf: [UInt8.max, UInt8.max, UInt8.max])
        
        for monitor in monitors {
            dataArray.append(contentsOf: [UInt8(monitor.rawValue)])
        }
        
        return dataArray
    }
    
}
