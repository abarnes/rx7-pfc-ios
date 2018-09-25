//
//  Threshold.swift
//  rx7
//
//  Created by Austin Barnes on 8/31/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

enum ThresholdType: String {
    case warning
    case critical
}

struct Threshold {
    
    private(set) var warning: ThresholdItem
    private(set) var critical: ThresholdItem
    
    init(warning: ThresholdItem, critical: ThresholdItem) {
        self.warning = warning
        self.critical = critical
    }
    
}
