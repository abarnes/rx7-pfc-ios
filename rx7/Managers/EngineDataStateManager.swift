//
//  EngineDataStateManager.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import Bond

class EngineDataStateManager {
    
    private(set) static var singleton = EngineDataStateManager()
    fileprivate(set) var current = Observable<BasicEngineData?>(nil)
    
    init() {
        BluetoothCentralManager.singleton.delegate = self
    }
    
}

extension EngineDataStateManager: BluetoothCentralManagerDelegate {
    
    func dataUpdateReceived(data: Data, forCharacteristic characteristic: BluetoothConfig.Characteristics) {
        guard (characteristic == BluetoothConfig.Characteristics.engineData) else { return }
        
        var basicEngineData = BasicEngineData(fromData: data)
        if (basicEngineData != nil) { // update
            if let location = GpsManager.singleton.findLocationForTime(basicEngineData.time) {
                basicEngineData.addLocation(location)
            }
            current.next(basicEngineData)
        }
    }
    
}
