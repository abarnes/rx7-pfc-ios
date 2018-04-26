//
//  EditThresholdViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 4/21/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

enum ThresholdType {
    case warning
    case critical
}

struct EditThresholdParameters {
    
    private var usesIntegers: Bool
    private var min: Double
    private var max: Double
    private var step: Double
    
    init(min: Double, max: Double, step: Double) {
        self.usesIntegers = false
        self.min = min
        self.max = max
        self.step = step
    }
    
    init(min: Int, max: Int, step: Int) {
        self.usesIntegers = true
        self.min = Double(min)
        self.max = Double(max)
        self.step = Double(step)
    }
    
}

struct EditThresholdViewModel {
    
    private(set) var dataItem: EngineDataItem
    private(set) var thresholdType: ThresholdType
    private(set) var currentValue: Double
    
    init(dataItem: EngineDataItem, thresholdType: ThresholdType) {
        self.dataItem = dataItem
        self.thresholdType = thresholdType
        self.currentValue = 0
    }
}
