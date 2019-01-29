//
//  BluetoothConfig.swift
//  rx7
//
//  Created by Austin Barnes on 3/8/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BluetoothConfig {
    
    static let enabledCharacteristics = [Characteristics.deviceLoad, Characteristics.engineData, Characteristics.gpsReceiver, Characteristics.thresholdConfig, Characteristics.layoutConfig, Characteristics.shutdown]
    
    struct Services {
        static let service = CBUUID(string: "f9d53a38-2324-11e8-b467-0ed5f89f718b")
    }
    
    enum Characteristics: String {
        case deviceLoad = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb10"
        case engineData = "f3f94f62-234e-11e8-b467-0ed5f89f718b"
        case gpsReceiver = "ab913146-2988-11e8-b467-0ed5f89f718b"
        case thresholdConfig = "e87a9de0-2fda-47ec-bc60-87ff31c9777f"
        case layoutConfig = "94667c9c-6888-41a6-9401-3655ebbfaf63"
        case shutdown = "382cccf9-9fdc-4ae0-8fc1-4570eabc3107"
        
        var asCBUUID: CBUUID {
            return CBUUID(string: self.rawValue)
        }
        
        
    }
}
