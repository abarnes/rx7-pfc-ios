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
        subscribeToEngineData()
    }
    
    private func subscribeToEngineData() {
        BluetoothManager.singleton.subscribe(to: BluetoothConfig.Characteristics.engineData) { [weak self] (data) in
            guard let data = data else { return }
            
            var basicEngineData = BasicEngineData(fromData: data)
            if (basicEngineData != nil) { // update
                if let location = GpsManager.singleton.findLocationForTime(basicEngineData.time) {
                    basicEngineData.addLocation(location)
                }
                self?.current.next(basicEngineData)
            }
        }
    }
    
}
