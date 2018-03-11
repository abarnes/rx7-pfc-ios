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
    
    func dataUpdateReceived(data: Data) {
        let basicEngineData = BasicEngineData(fromData: data)
        if (basicEngineData != nil) { // update
            current.next(basicEngineData)
        }
    }
    
}
