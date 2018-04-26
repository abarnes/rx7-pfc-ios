//
//  EngineDataItem.swift
//  rx7
//
//  Created by Austin Barnes on 4/16/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

enum EngineDataItem: Int {
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
    
    static var count: Int { return EngineDataItem.batteryVoltage.hashValue + 1 }
    
    var editThresholdParameters: EditThresholdParameters {
        switch self {
        case .rpm:
            return EditThresholdParameters(min: 0, max: 30000, step: 10)
        case .boost:
            return EditThresholdParameters(min: -5000, max: 5000, step: 10)
        case .waterTemp:
            return EditThresholdParameters(min: -50, max: 200, step: 1)
        case .knock:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .injectorDuty:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .leadingIgnition:
            return EditThresholdParameters(min: -100, max: 100, step: 1)
        case .trailingIgnition:
            return EditThresholdParameters(min: -100, max: 100, step: 1)
        case .speed:
            return EditThresholdParameters(min: 0, max: 300, step: 1)
        case .airTemp:
            return EditThresholdParameters(min: -50, max: 200, step: 1)
        case .batteryVoltage:
            return EditThresholdParameters(min: 0.0, max: 20.0, step: 0.1)
        }
    }
}
