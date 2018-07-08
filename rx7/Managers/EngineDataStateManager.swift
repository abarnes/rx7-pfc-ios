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
    fileprivate(set) var current = Observable<EngineDataPoint?>(nil)
    
    init() {
        subscribeToEngineData()
    }
    
    private func subscribeToEngineData() {
        BluetoothManager.singleton.subscribe(to: BluetoothConfig.Characteristics.engineData) { [weak self] (data) in
            guard let data = data else { return }
            
            var basicEngineData = EngineDataPoint(fromData: data)
            if let time = basicEngineData.time, let location = GpsManager.singleton.findLocationForTime(time) {
                basicEngineData.addLocation(location)
            }
            self?.current.next(basicEngineData)
            
        }
    }
    
}
