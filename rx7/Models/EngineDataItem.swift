//
//  EngineDataItem.swift
//  rx7
//
//  Created by Austin Barnes on 4/16/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

/*
 * This model is used to drive the Gauges page.  It describes the types of data points available.
 */

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
    case batteryVoltage
    
    case intakePressure
    case mapSensorVoltage
    case tpsVoltage
    case primaryInjectorPulse
    case fuelCorrection
    case fuelTemp
    case mopPosition
    case boostTP
    case boostWG
    case intakeTemp
    case iscvDuty
    case o2Voltage
    case secondaryInjectorPulse
    
    case tpsFullRangeVoltage
    case tpsNarrowRangeVoltage
    case mopPositionSensorVoltage
    case waterTempSensorVoltage
    case intakeAirTempSensorVoltage
    case fuelTempSensorVoltage
    case o2SensorVoltage
    case starterSwitch
    case airConditioningSwitch
    case powerSteeringPressureSwitch
    case neutralSwitch
    case clutchSwitch
    case stopSwitch
    case catalyzerThermoSensorSwitch
    case electricalLoadSwitch
    case exhaustTempWarningIndicator
    case fuelPumpOperation
    case fuelPumpControl
    case airPumpRelay
    case portAirControl
    case chargeControl
    case turboControl
    case pressureRegulatorControl
    
    // static var count: Int { return EngineDataItem.pressureRegulatorControl.hashValue + 1 } // TODO figure out why this broke in iOS 12
    static var count: Int { return 46 }
    
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
        case .intakePressure:
            return "Intake Pressure"
        case .mapSensorVoltage:
            return "Map Sensor Voltage"
        case .tpsVoltage:
            return "TPS Voltage"
        case .primaryInjectorPulse:
            return "Primary Injector Pulse"
        case .fuelCorrection:
            return "Fuel Correction"
        case .fuelTemp:
            return "Fuel Temp"
        case .mopPosition:
            return "MOP Position"
        case .boostTP:
            return "Boost TP"
        case .boostWG:
            return "Boost WG"
        case .intakeTemp:
            return "Intake Temp"
        case .iscvDuty:
            return "ISCV Duty"
        case .o2Voltage:
            return "O2 Voltage"
        case .secondaryInjectorPulse:
            return "Secondary Injector Pulse"
        case .tpsFullRangeVoltage:
            return "TPS Full Range Voltage"
        case .tpsNarrowRangeVoltage:
            return "TPS Narrow Range Voltage"
        case .mopPositionSensorVoltage:
            return "MOP Position Sensor Voltage"
        case .waterTempSensorVoltage:
            return "Water Temp Sensor Voltage"
        case .intakeAirTempSensorVoltage:
            return "Intake Air Temp Sensor Voltage"
        case .fuelTempSensorVoltage:
            return "Fuel Temp Sensor Voltage"
        case .o2SensorVoltage:
            return "O2 Sensor Voltage"
        case .starterSwitch:
            return "Starter Switch"
        case .airConditioningSwitch:
            return "Air Conditioning Switch"
        case .powerSteeringPressureSwitch:
            return "Power Steering Pressure Switch"
        case .neutralSwitch:
            return "Neutral Switch"
        case .clutchSwitch:
            return "Clutch Switch"
        case .stopSwitch:
            return "Stop Switch"
        case .catalyzerThermoSensorSwitch:
            return "Catalyzer Thermo Sensor Switch"
        case .electricalLoadSwitch:
            return "Electrical Load Switch"
        case .exhaustTempWarningIndicator:
            return "Exhaust Temp Warning Indicator"
        case .fuelPumpOperation:
            return "Fuel Pump Operation"
        case .fuelPumpControl:
            return "Fuel Pump Control"
        case .airPumpRelay:
            return "Air Pump Relay"
        case .portAirControl:
            return "Port Air Control"
        case .chargeControl:
            return "Charge Control"
        case .turboControl:
            return "Turbo Control"
        case .pressureRegulatorControl:
            return "Pressure Regulator Control"
        // If anything gets added, update the count property below
        }
    }
    
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
        case .intakePressure:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .mapSensorVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .tpsVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .primaryInjectorPulse:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .fuelCorrection:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .fuelTemp:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .mopPosition:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .boostTP:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .boostWG:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .intakeTemp:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .iscvDuty:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .o2Voltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .secondaryInjectorPulse:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .tpsFullRangeVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .tpsNarrowRangeVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .mopPositionSensorVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .waterTempSensorVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .intakeAirTempSensorVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .fuelTempSensorVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .o2SensorVoltage:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .starterSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .airConditioningSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .powerSteeringPressureSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .neutralSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .clutchSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .stopSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .catalyzerThermoSensorSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .electricalLoadSwitch:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .exhaustTempWarningIndicator:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .fuelPumpOperation:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .fuelPumpControl:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .airPumpRelay:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .portAirControl:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .chargeControl:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .turboControl:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        case .pressureRegulatorControl:
            return EditThresholdParameters(min: 0, max: 100, step: 1)
        }
    }
    
}
