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
    private(set) var warningValue: Double?
    private(set) var errorValue: Double?
    
    init(dataItem: EngineDataItem) {
        self.title = dataItem.title
        
        // TODO - hook up actual threshold config code
        
    }
    
}
