//
//  ThresholdItem.swift
//  rx7
//
//  Created by Austin Barnes on 8/31/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

struct ThresholdItem {
    private(set) var enabled: Bool
    private(set) var greaterThan: Bool
    private(set) var value: Double
    
    init(isEnabled enabled: Bool, greaterThan: Bool, value: Double) {
        self.enabled = enabled
        self.greaterThan = greaterThan
        self.value = value
    }
}
