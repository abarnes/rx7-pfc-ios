//
//  ThresholdConfigTableViewCellViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 4/16/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

class ThresholdConfigTableViewCellViewModel {
    
    private(set) var title: String
    private(set) var warningValue = "No warning"
    private(set) var criticalValue = "No critical"
    
    init(dataItem: EngineDataItem) {
        self.title = dataItem.title
        
        ThresholdConfigManager.singleton.getThreshold(for: dataItem) { [weak self] (threshold) in
            guard let `self` = self, let threshold = threshold else { return }
            
            if (threshold.warning.enabled) {
                self.warningValue = "Warn \(threshold.warning.greaterThan ? ">" : "<")\(threshold.warning.value)"
            }
            
            if (threshold.critical.enabled) {
                self.criticalValue = "Critical \(threshold.critical.greaterThan ? ">" : "<")\(threshold.critical.value)"
            }
        }
        
    }
    
}
