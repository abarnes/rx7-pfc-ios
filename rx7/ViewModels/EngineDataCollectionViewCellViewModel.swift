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

// this might need to move somewhere else
enum GaugeType: Int {
    case rpm = 0
    case boost
    case waterTemp
    case knock
    case injectorDuty
    case leadingIgnition
    case trailingIgnition
    case speed
    case airTemp
    case batteryVoltage // must be last
    
    var title: String {
        switch self {
        case .rpm:
            return "RPM"
        case .boost:
            return "Boost"
        case .waterTemp:
            return "Water Temp"
        case .knock:
            return "Knock"
        case .injectorDuty:
            return "Injector Duty"
        case .leadingIgnition:
            return "Leading Ignition"
        case .trailingIgnition:
            return "Trailing Ignition"
        case .speed:
            return "Speed (MPH)"
        case .airTemp:
            return "Air Temp"
        case .batteryVoltage:
            return "Battery Voltage"
        }
    }
    
    static var count: Int { return GaugeType.batteryVoltage.hashValue + 1 }
}

class EngineDataCollectionViewCellViewModel {
    
    var disposeBag = DisposeBag()
    private(set) var title: String
    private(set) var value = Observable<String>("")
    
    init(gauge: GaugeType) {
        title = gauge.title
        
        setupObservers(forKey: gauge)
    }
    
    private func setupObservers(forKey key: GaugeType) {
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
