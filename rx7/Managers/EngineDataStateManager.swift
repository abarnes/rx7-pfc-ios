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
            guard let `self` = self, let data = data else { return }
            
            var newData = EngineDataPoint(fromData: data)
            if let time = newData.time, let location = GpsManager.singleton.findLocationForTime(time) {
                newData.addLocation(location)
            }
            
            if let currentData = self.current.value {
                self.current.next(currentData.supercede(with: newData))
            } else {
                self.current.next(newData)
            }
        }
    }
    
}
