//
//  EditThresholdParameters.swift
//  rx7
//
//  Created by Austin Barnes on 8/31/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

struct EditThresholdParameters {
    
    private(set) var usesIntegers: Bool
    private(set) var min: Double
    private(set) var max: Double
    private(set) var step: Double
    
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
