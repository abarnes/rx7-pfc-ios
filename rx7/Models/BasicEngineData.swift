//
//  BasicEngineData.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import CoreLocation

struct BasicEngineData {
    
    private(set) var time: Int
    private(set) var boost: Int
    private(set) var waterTemp: Int
    private(set) var knock: Int
    private(set) var injectorDuty: Int
    private(set) var leadingIgnition: Int
    private(set) var trailingIgnition: Int
    private(set) var speed: Int
    private(set) var airTemp: Int
    private(set) var batteryVoltage: Double
    private(set) var rpm: Int
    private(set) var location: CLLocationCoordinate2D?
    
    init(fromData data: Data) {
        guard (data.count > 24) else {
            fatalError("Attempted to initialize BasicEngineData with insufficient data (\(data.count) bytes)")
        }
        
        // command = first two bytes
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
    }
    
    mutating func addLocation(_ location: CLLocationCoordinate2D) {
        self.location = location
    }
    
}
