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
            
            default:
                return
        }
        
    }
    
    mutating func addLocation(_ location: CLLocationCoordinate2D) {
        self.location = location
    }
    
}
