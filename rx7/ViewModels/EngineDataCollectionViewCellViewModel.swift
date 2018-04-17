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

class EngineDataCollectionViewCellViewModel {
    
    var disposeBag = DisposeBag()
    private(set) var title: String
    private(set) var value = Observable<String>("")
    
    init(gauge: EngineDataItem) {
        title = gauge.title
        
        setupObservers(forKey: gauge)
    }
    
    private func setupObservers(forKey key: EngineDataItem) {
        EngineDataStateManager.singleton.current.observeNext { [weak self] (engineData) in
            guard let engineData = engineData else { return }
            switch key {
            case .rpm:
                self?.value.next("\(engineData.rpm)")
            case .boost:
                self?.value.next("\(engineData.boost)")
            case .waterTemp:
                self?.value.next("\(engineData.waterTemp)")
            case .knock:
                self?.value.next("\(engineData.knock)")
            case .injectorDuty:
                self?.value.next("\(engineData.injectorDuty)")
            case .leadingIgnition:
                self?.value.next("\(engineData.leadingIgnition)")
            case .trailingIgnition:
                self?.value.next("\(engineData.trailingIgnition)")
            case .speed:
                self?.value.next("\(engineData.speed)")
            case .airTemp:
                self?.value.next("\(engineData.airTemp)")
            case .batteryVoltage:
                self?.value.next("\(engineData.batteryVoltage)")
            }
        }.dispose(in: disposeBag)
    }
    
}
