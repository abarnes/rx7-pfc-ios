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
    private(set) var dataset: LineChartDataSet
    private(set) var shouldUpdateChart = Observable<Bool>(false)
    
    let MAX_CHART_DATAPOINTS = 20
    
    private var iterator = 1.0
    
    init(gauge: EngineDataItem) {
        title = gauge.title
        
        let point1 = ChartDataEntry(x: 0, y: 5)
        let point2 = ChartDataEntry(x: 1, y: 20)
        
        dataset = LineChartDataSet(entries: [point1, point2], label: "")
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let `self` = self else { return }
            self.value.send("17")
            
            self.dataset.append(ChartDataEntry(x: self.iterator, y: 17))
            self.iterator += 1
            if (self.dataset.count > self.MAX_CHART_DATAPOINTS) {
                let _ = self.dataset.remove(at: 0)
            }
            self.shouldUpdateChart.send(!self.shouldUpdateChart.value)
        }
    }
    
    private func setupObservers(forKey key: EngineDataItem) {
        EngineDataStateManager.singleton.current.observeNext { [weak self] (engineData) in
            guard let `self` = self, let engineData = engineData, let item = engineData[key] else { return }
            self.value.send("\(item)")
            
            if let numberValue = item as? Double {
                if (self.dataset.count == self.MAX_CHART_DATAPOINTS) {
                    let _ = self.dataset.remove(at: 0)
                }
                self.dataset.append(ChartDataEntry(x: Double(self.dataset.count), y: numberValue))
                self.shouldUpdateChart.send(true)
            }
            
        }.dispose(in: disposeBag)
    }
    
}
