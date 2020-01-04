//
//  EngineDataStateManager.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import Bond

class MockEngineDataStateManager: EngineDataStateManagerProtocol {
    private(set) static var singleton: EngineDataStateManagerProtocol = MockEngineDataStateManager()
    fileprivate(set) var current = Observable<EngineDataPoint?>(nil)
    fileprivate(set) var didBeginDrive = Observable<Bool>(false)
    
    init() {
        current.send(generateDataPoint())
        didBeginDrive.send(true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.current.send(self?.generateDataPoint())
        }
    }
    
    func getCurrentDataPointByKey(_ key: EngineDataItem) -> Any? {
        return nil
    }
    
    private func generateDataPoint() -> EngineDataPoint {
        var newDataPoint = EngineDataPoint()
        
        newDataPoint.rpm = current.value == nil ? 1500 : current.value!.rpm! + Int.random(in: -400 ..< 400)

        return newDataPoint
    }
    
}
