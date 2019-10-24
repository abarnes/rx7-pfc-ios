//
//  EngineDataCollectionViewCellViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import Charts

class EngineDataCollectionViewCellViewModel {
    
    var disposeBag = DisposeBag()
    private(set) var title: String
    private(set) var value = Observable<String>("")
    let graphData = LineChartData()
    private var dataset = LineChartDataSet(entries: nil, label: "")
    
    init(gauge: EngineDataItem) {
        title = gauge.title
        graphData.addDataSet(dataset)
        
        setupObservers(forKey: gauge)
    }
    
    private func setupObservers(forKey key: EngineDataItem) {
        EngineDataStateManager.singleton.current.observeNext { [weak self] (engineData) in
            guard let engineData = engineData, let item = engineData[key] else { return }
            self?.value.send("\(item)")
            let point = ChartDataEntry(x: 1, y: (item as? Double ?? 0))
            
        }.dispose(in: disposeBag)
    }
    
}
