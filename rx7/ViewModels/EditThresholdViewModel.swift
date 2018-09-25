//
//  EditThresholdViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 8/31/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import Bond

class EditThresholdViewModel {
    
    private(set) var type: ThresholdType
    private(set) var editParameters: EditThresholdParameters
    
    private(set) var currentValue = Observable<Double>(0)
    private(set) var currentIsGreaterThan = Observable<Bool>(true)
    private(set) var currentEnabled = Observable<Bool>(true)
    
    init(type: ThresholdType, value: ThresholdItem, editParameters: EditThresholdParameters) {
        self.type = type
        self.editParameters = editParameters
        
        currentValue.next(value.value)
        currentIsGreaterThan.next(value.greaterThan)
        currentEnabled.next(value.enabled)
    }
    
    func updateCurrentValue(_ value: Double) {
        currentValue.next(value)
    }
    
    func toggleEnabled(_ enabled: Bool) {
        print("Toggling threshold enabled: \(enabled)")
        currentEnabled.next(enabled)
    }
    
    func toggleDirection(isGreaterThan: Bool) {
        print("Direction changed isGreaterThan: \(isGreaterThan)")
        currentIsGreaterThan.next(isGreaterThan)
    }
    
    
    
}
