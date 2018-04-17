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
}
