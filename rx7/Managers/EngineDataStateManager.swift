//
//  EngineDataStateManager.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import Bond

protocol EngineDataStateManagerProtocol {
    static var singleton: EngineDataStateManagerProtocol { get }
    var current: Observable<EngineDataPoint?> { get }
    var didBeginDrive: Observable<Bool> { get }
    func getCurrentDataPointByKey(_ key: EngineDataItem) -> Any?
}

class EngineDataStateManager: EngineDataStateManagerProtocol {
    private(set) static var singleton: EngineDataStateManagerProtocol = EngineDataStateManager()
    fileprivate(set) var current = Observable<EngineDataPoint?>(nil)
    fileprivate(set) var didBeginDrive = Observable<Bool>(false)
    
    init() {
        subscribeToEngineData()
    }
    
    func getCurrentDataPointByKey(_ key: EngineDataItem) -> Any? {
        
        
        return nil
    }
    
    private func subscribeToEngineData() {
        BluetoothManager.singleton.subscribe(to: BluetoothConfig.Characteristics.engineData) { [weak self] (data) in
            guard let `self` = self, let data = data else { return }
            
            var newData = EngineDataPoint(fromData: data)
            if let time = newData.time, let location = GpsManager.singleton.findLocationForTime(time) {
                newData.addLocation(location)
            }
            
            if (!self.didBeginDrive.value && ((newData.rpm ?? 0) > 1)) {
                self.didBeginDrive.send(true)
            }
            
            if let currentData = self.current.value {
                self.current.send(currentData.supercede(with: newData))
            } else {
                self.current.send(newData)
            }
        }
    }
    
}
