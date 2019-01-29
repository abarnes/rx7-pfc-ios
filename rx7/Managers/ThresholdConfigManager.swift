//
//  ThresholdDataManager.swift
//  rx7
//
//  Created by Austin Barnes on 8/31/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

class ThresholdConfigManager {
    
    static let singleton = ThresholdConfigManager()
    
    private var hasFetchedData = false
    private var itemToGetAfterFetch: EngineDataItem?
    private var callbackAfterFetch: ((Threshold?) -> Void)?
    
    private var thresholds: [EngineDataItem: Threshold] = [:]
    
    init() {
        // TODO replace with the real code
        let warning = ThresholdItem(isEnabled: true, greaterThan: true, value: 8000)
        let critical = ThresholdItem(isEnabled: true, greaterThan: true, value: 8500)
        thresholds[EngineDataItem.rpm] = Threshold(warning: warning, critical: critical)
        
        BluetoothManager.singleton.read(characteristic: .thresholdConfig) { [weak self] (data) in
            guard let data = data else { return }
            
            self?.initialize(withData: data)
        }
    }
    
    func getThreshold(for item: EngineDataItem, _ handler: @escaping ((Threshold?) -> Void)) {
        /*
        guard hasFetchedData else {
            itemToGetAfterFetch = item
            callbackAfterFetch = handler
            return
        }*/
        
        handler(thresholds[item])
    }
    
    func setThreshold(_ threshold: Threshold, for item: EngineDataItem, _ successHandler: ((Bool) -> Void)?) {
        // TODO set this over bluetooth
        
        thresholds[item] = threshold
        successHandler?(true)
    }
    
    private func initialize(withData data: Data) {
        
        // loop through data and convert
        
        hasFetchedData = true
        
        guard let item = itemToGetAfterFetch, let handler = callbackAfterFetch else { return }
        handler(thresholds[item])
        itemToGetAfterFetch = nil
        callbackAfterFetch = nil
    }
    
}
