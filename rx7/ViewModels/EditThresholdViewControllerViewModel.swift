//
//  EditThresholdViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 4/21/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

struct EditThresholdViewControllerViewModel {
    private(set) var dataItem: EngineDataItem
    private(set) var editParameters: EditThresholdParameters
    private(set) var currentValue: Threshold
    
    init(dataItem: EngineDataItem, threshold: Threshold, parameters: EditThresholdParameters) {
        self.dataItem = dataItem
        self.editParameters = parameters
        self.currentValue = threshold
    }
}
