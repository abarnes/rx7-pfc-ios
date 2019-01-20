//
//  File.swift
//  rx7
//
//  Created by Austin Barnes on 7/8/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import CoreLocation

struct EngineDataPoint {
    
    private(set) var time: Int?
    private(set) var boost: Int?
    private(set) var waterTemp: Int?
    private(set) var knock: Int?
    private(set) var injectorDuty: Int?
    private(set) var leadingIgnition: Int?
    private(set) var trailingIgnition: Int?
    private(set) var speed: Int?
    private(set) var airTemp: Int?
    private(set) var batteryVoltage: Double?
    private(set) var rpm: Int?
    
    private(set) var location: CLLocationCoordinate2D?
    
    private(set) var intakePressure: Int?
    private(set) var mapSensorVoltage: Double?
    private(set) var tpsVoltage: Double?
    private(set) var primaryInjectorPulse: Int?
    private(set) var fuelCorrection: Int?
    private(set) var fuelTemp: Int?
    private(set) var mopPosition: Int?
    private(set) var boostTP: Int?
    private(set) var boostWG: Int?
    private(set) var intakeTemp: Int?
    private(set) var iscvDuty: Int?
    private(set) var o2Voltage: Double?
    private(set) var secondaryInjectorPulse: Int?
    
    private(set) var tpsFullRangeVoltage: Double?
    private(set) var tpsNarrowRangeVoltage: Double?
    private(set) var mopPositionSensorVoltage: Double?
    private(set) var waterTempSensorVoltage: Double?
    private(set) var intakeAirTempSensorVoltage: Double?
    private(set) var fuelTempSensorVoltage: Double?
    private(set) var o2SensorVoltage: Double? // ------ is this distinct from o2Voltage?
    private(set) var starterSwitch: Bool?
    private(set) var airConditioningSwitch: Bool?
    private(set) var powerSteeringPressureSwitch: Bool?
    private(set) var neutralSwitch: Bool?
    private(set) var clutchSwitch: Bool?
    private(set) var stopSwitch: Bool?
    private(set) var catalyzerThermoSensorSwitch: Bool?
    private(set) var electricalLoadSwitch: Bool?
    private(set) var exhaustTempWarningIndicator: Bool?
    private(set) var fuelPumpOperation: Bool?
    private(set) var fuelPumpControl: Bool?
    private(set) var airPumpRelay: Bool?
    private(set) var portAirControl: Bool?
    private(set) var chargeControl: Bool?
    private(set) var turboControl: Bool?
    private(set) var pressureRegulatorControl: Bool?
    
    fileprivate init() {
            // no-op
    }
    
    init(fromData data: Data) {
        guard (data.count > 2) else {
            print("Attempted to initialize EngineDataPoint with insufficient data: (\(data.count) bytes)")
            return
        }
        
        // command = first two bytes
        let command = Int(data[0..<1].to(UInt8.self))
        switch (command) {
            case 218: // basic
                time = Int(data[2..<10].to(UInt64.self))
                boost = Int(data[10..<12].to(Int16.self))
                waterTemp = (Int(data[12..<13].to(UInt8.self)) - 40)
                knock = Int(data[13..<14].to(UInt8.self))
                injectorDuty = Int(data[14..<16].to(UInt16.self))
                leadingIgnition = Int(data[16..<17].to(Int8.self))
                trailingIgnition = Int(data[17..<18].to(Int8.self))
                speed = Int(data[18..<20].to(UInt16.self))
                airTemp = (Int(data[20..<21].to(UInt8.self)) - 40)
                batteryVoltage = (Double(data[21..<23].to(UInt16.self)) / 10)
                rpm = data[23..<25].to(Int.self)
            
            case 240: // advanced
                time = Int(data[2..<10].to(UInt64.self))
                rpm = Int(data[10..<12].to(UInt16.self))
                intakePressure = Int(data[12..<14].to(Int16.self))
                mapSensorVoltage = (Double(data[14..<16].to(UInt16.self)) / 10)
                tpsVoltage = (Double(data[16..<18].to(UInt16.self)) / 10)
                primaryInjectorPulse = Int(data[18..<20].to(UInt16.self))
                fuelCorrection = Int(data[20..<22].to(UInt16.self))
                leadingIgnition = Int(data[22..<23].to(Int8.self))
                trailingIgnition = Int(data[23..<24].to(Int8.self))
                fuelTemp = (Int(data[24..<25].to(UInt8.self)) - 40)
                mopPosition = Int(data[25..<26].to(UInt8.self))
                boostTP = Int(data[26..<27].to(UInt8.self))
                boostWG = Int(data[27..<28].to(UInt8.self))
                waterTemp = (Int(data[28..<29].to(UInt8.self)) - 40)
                intakeTemp = (Int(data[29..<30].to(UInt8.self)) - 40)
                knock = Int(data[30..<31].to(UInt8.self))
                batteryVoltage = (Double(data[31..<33].to(UInt16.self)) / 10)
                speed = Int(data[33..<35].to(UInt16.self))
                iscvDuty = Int(data[35..<37].to(UInt16.self))
                o2Voltage = (Double(data[37..<39].to(UInt16.self)) / 10)
                secondaryInjectorPulse = Int(data[39..<41].to(UInt16.self))
            
            case 222: // sensor data
                time = Int(data[2..<10].to(UInt64.self))
                mapSensorVoltage = (Double(data[10..<12].to(UInt16.self)) / 10)
                tpsFullRangeVoltage = (Double(data[12..<14].to(UInt16.self)) / 10)
                tpsNarrowRangeVoltage = (Double(data[14..<16].to(UInt16.self)) / 10)
                mopPositionSensorVoltage = (Double(data[16..<18].to(UInt16.self)) / 10)
                waterTempSensorVoltage = (Double(data[18..<20].to(UInt16.self)) / 10)
                intakeAirTempSensorVoltage = (Double(data[20..<22].to(UInt16.self)) / 10)
                fuelTempSensorVoltage = (Double(data[22..<24].to(UInt16.self)) / 10)
                o2SensorVoltage = (Double(data[24..<26].to(UInt16.self)) / 10)
            
                starterSwitch = Int(data[26..<27].to(UInt8.self)) == 1
                airConditioningSwitch = Int(data[27..<28].to(UInt8.self)) == 1
                powerSteeringPressureSwitch = Int(data[28..<29].to(UInt8.self)) == 1
                neutralSwitch = Int(data[29..<30].to(UInt8.self)) == 1
                clutchSwitch = Int(data[30..<31].to(UInt8.self)) == 1
                stopSwitch = Int(data[31..<32].to(UInt8.self)) == 1
                catalyzerThermoSensorSwitch = Int(data[32..<33].to(UInt8.self)) == 1
                electricalLoadSwitch = Int(data[33..<34].to(UInt8.self)) == 1
                exhaustTempWarningIndicator = Int(data[34..<35].to(UInt8.self)) == 1
                fuelPumpOperation = Int(data[35..<36].to(UInt8.self)) == 1
                fuelPumpControl = Int(data[36..<37].to(UInt8.self)) == 1
                airPumpRelay = Int(data[37..<38].to(UInt8.self)) == 1
                portAirControl = Int(data[38..<39].to(UInt8.self)) == 1
                chargeControl = Int(data[39..<40].to(UInt8.self)) == 1
                turboControl = Int(data[40..<41].to(UInt8.self)) == 1
                pressureRegulatorControl = Int(data[41..<42].to(UInt8.self)) == 1
            
            default:
                return
        }
        
    }
    
    mutating func addLocation(_ location: CLLocationCoordinate2D) {
        self.location = location
    }
    
    func supercede(with data: EngineDataPoint) -> EngineDataPoint {
        var newDataPoint = EngineDataPoint()
        
        newDataPoint.time = data.time
        newDataPoint.boost = data.boost ?? self.boost
        newDataPoint.waterTemp = data.waterTemp ?? self.waterTemp
        newDataPoint.knock = data.knock ?? self.knock
        newDataPoint.injectorDuty = data.injectorDuty ?? self.injectorDuty
        newDataPoint.leadingIgnition = data.leadingIgnition ?? self.leadingIgnition
        newDataPoint.trailingIgnition = data.trailingIgnition ?? self.trailingIgnition
        newDataPoint.speed = data.speed ?? self.speed
        newDataPoint.airTemp = data.airTemp ?? self.airTemp
        newDataPoint.batteryVoltage = data.batteryVoltage ?? self.batteryVoltage
        newDataPoint.rpm = data.rpm ?? self.rpm
        
        newDataPoint.intakePressure = data.intakePressure ?? self.intakePressure
        newDataPoint.mapSensorVoltage = data.mapSensorVoltage ?? self.mapSensorVoltage
        newDataPoint.tpsVoltage = data.tpsVoltage ?? self.tpsVoltage
        newDataPoint.primaryInjectorPulse = data.primaryInjectorPulse ?? self.primaryInjectorPulse
        newDataPoint.fuelCorrection = data.fuelCorrection ?? self.fuelCorrection
        newDataPoint.fuelTemp = data.fuelTemp ?? self.fuelTemp
        newDataPoint.mopPosition = data.mopPosition ?? self.mopPosition
        newDataPoint.boostTP = data.boostTP ?? self.boostTP
        newDataPoint.boostWG = data.boostWG ?? self.boostWG
        newDataPoint.intakeTemp = data.intakeTemp ?? self.intakeTemp
        newDataPoint.iscvDuty = data.iscvDuty ?? self.iscvDuty
        newDataPoint.o2Voltage = data.o2Voltage ?? self.o2Voltage
        newDataPoint.secondaryInjectorPulse = data.secondaryInjectorPulse ?? self.secondaryInjectorPulse
        
        newDataPoint.tpsFullRangeVoltage = data.tpsFullRangeVoltage ?? self.tpsFullRangeVoltage
        newDataPoint.tpsNarrowRangeVoltage = data.tpsNarrowRangeVoltage ?? self.tpsNarrowRangeVoltage
        newDataPoint.mopPositionSensorVoltage = data.mopPositionSensorVoltage ?? self.mopPositionSensorVoltage
        newDataPoint.waterTempSensorVoltage = data.waterTempSensorVoltage ?? self.waterTempSensorVoltage
        newDataPoint.intakeAirTempSensorVoltage = data.intakeAirTempSensorVoltage ?? self.intakeAirTempSensorVoltage
        newDataPoint.fuelTempSensorVoltage = data.fuelTempSensorVoltage ?? self.fuelTempSensorVoltage
        newDataPoint.o2SensorVoltage = data.o2SensorVoltage ?? self.o2SensorVoltage
        
        newDataPoint.starterSwitch = data.starterSwitch ?? self.starterSwitch
        newDataPoint.airConditioningSwitch = data.airConditioningSwitch ?? self.airConditioningSwitch
        newDataPoint.powerSteeringPressureSwitch = data.powerSteeringPressureSwitch ?? self.powerSteeringPressureSwitch
        newDataPoint.neutralSwitch = data.neutralSwitch ?? self.neutralSwitch
        newDataPoint.clutchSwitch = data.clutchSwitch ?? self.clutchSwitch
        newDataPoint.stopSwitch = data.stopSwitch ?? self.stopSwitch
        newDataPoint.catalyzerThermoSensorSwitch = data.catalyzerThermoSensorSwitch ?? self.catalyzerThermoSensorSwitch
        newDataPoint.electricalLoadSwitch = data.electricalLoadSwitch ?? self.electricalLoadSwitch
        newDataPoint.exhaustTempWarningIndicator = data.exhaustTempWarningIndicator ?? self.exhaustTempWarningIndicator
        newDataPoint.fuelPumpOperation = data.fuelPumpOperation ?? self.fuelPumpOperation
        newDataPoint.fuelPumpControl = data.fuelPumpControl ?? self.fuelPumpControl
        newDataPoint.airPumpRelay = data.airPumpRelay ?? self.airPumpRelay
        newDataPoint.portAirControl = data.portAirControl ?? self.portAirControl
        newDataPoint.chargeControl = data.chargeControl ?? self.chargeControl
        newDataPoint.turboControl = data.turboControl ?? self.turboControl
        newDataPoint.pressureRegulatorControl = data.pressureRegulatorControl ?? self.pressureRegulatorControl
        
        return newDataPoint
    }
    
    func convertToFirestoreData() -> [String: Any] {
        var timestamp: Double = 0
        if let time = self.time {
            timestamp = Double(time) / 1000
        }
        
        return [
            "timestamp": timestamp,
            "boost": self.boost as Any,
            "waterTemp": self.waterTemp as Any,
            "knock": self.knock as Any,
            "injectorDuty": self.injectorDuty as Any,
            "leadingIgnition": self.leadingIgnition as Any,
            "trailingIgnition": self.trailingIgnition as Any,
            "speed": self.speed as Any,
            "airTemp": self.airTemp as Any,
            "batteryVoltage": self.batteryVoltage as Any,
            "rpm": self.rpm as Any
        ]
    }
    
    subscript(key: EngineDataItem) -> Any? {
        switch key {
        case .rpm:
            return self.rpm
        case .boost:
            return self.boost
        case .waterTemp:
            return self.waterTemp
        case .knock:
            return self.knock
        case .injectorDuty:
            return self.injectorDuty
        case .leadingIgnition:
            return self.leadingIgnition
        case .trailingIgnition:
            return self.trailingIgnition
        case .speed:
            return self.speed
        case .airTemp:
            return self.airTemp
        case .batteryVoltage:
            return self.batteryVoltage
        case .intakePressure:
            return self.intakePressure
        case .mapSensorVoltage:
            return self.mapSensorVoltage
        case .tpsVoltage:
            return self.tpsVoltage
        case .primaryInjectorPulse:
            return self.primaryInjectorPulse
        case .fuelCorrection:
            return self.fuelCorrection
        case .fuelTemp:
            return self.fuelTemp
        case .mopPosition:
            return self.mopPosition
        case .boostTP:
            return self.boostTP
        case .boostWG:
            return self.boostWG
        case .intakeTemp:
            return self.intakeTemp
        case .iscvDuty:
            return self.iscvDuty
        case .o2Voltage:
            return self.o2Voltage
        case .secondaryInjectorPulse:
            return self.secondaryInjectorPulse
        case .tpsFullRangeVoltage:
            return self.tpsFullRangeVoltage
        case .tpsNarrowRangeVoltage:
            return self.tpsNarrowRangeVoltage
        case .mopPositionSensorVoltage:
            return self.mopPositionSensorVoltage
        case .waterTempSensorVoltage:
            return self.waterTempSensorVoltage
        case .intakeAirTempSensorVoltage:
            return self.intakeAirTempSensorVoltage
        case .fuelTempSensorVoltage:
            return self.fuelTempSensorVoltage
        case .o2SensorVoltage:
            return self.o2SensorVoltage
        case .starterSwitch:
            return self.starterSwitch
        case .airConditioningSwitch:
            return self.airConditioningSwitch
        case .powerSteeringPressureSwitch:
            return self.powerSteeringPressureSwitch
        case .neutralSwitch:
            return self.neutralSwitch
        case .clutchSwitch:
            return self.clutchSwitch
        case .stopSwitch:
            return self.stopSwitch
        case .catalyzerThermoSensorSwitch:
            return self.catalyzerThermoSensorSwitch
        case .electricalLoadSwitch:
            return self.electricalLoadSwitch
        case .exhaustTempWarningIndicator:
            return self.exhaustTempWarningIndicator
        case .fuelPumpOperation:
            return self.fuelPumpOperation
        case .fuelPumpControl:
            return self.fuelCorrection
        case .airPumpRelay:
            return self.airPumpRelay
        case .portAirControl:
            return self.portAirControl
        case .chargeControl:
            return self.chargeControl
        case .turboControl:
            return self.turboControl
        case .pressureRegulatorControl:
            return self.pressureRegulatorControl
        }
    }
    
}
