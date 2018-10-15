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
    
    private let bluetoothManager = BluetoothManager.singleton
    
    func readGauges(_ completionHandler: @escaping ([EngineDataItem], [EngineDataItem]) -> Void) {
        let gauges: [EngineDataItem] = [.rpm, .boost, .injectorDuty, .batteryVoltage, .knock]
        let monitors: [EngineDataItem] = [.electricalLoadSwitch, .waterTemp, .intakeTemp]
        completionHandler(gauges, monitors)
    }
    
    func setGauges(gauges: [EngineDataItem], monitors: [EngineDataItem], _ completionHandler: ((Bool) -> Void)?) {
        // save the data
        
        completionHandler?(true)
    }
    
}
