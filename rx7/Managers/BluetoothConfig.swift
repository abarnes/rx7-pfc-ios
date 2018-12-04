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
    
    static let enabledCharacteristics = [Characteristics.deviceLoad, Characteristics.engineData, Characteristics.gpsReceiver, Characteristics.thresholdConfig, Characteristics.layoutConfig]
    
    struct Services {
        static let service = CBUUID(string: "f9d53a38-2324-11e8-b467-0ed5f89f718b")
    }
    
    enum Characteristics: String {
        case deviceLoad = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb10"
        case engineData = "f3f94f62-234e-11e8-b467-0ed5f89f718b"
        case gpsReceiver = "ab913146-2988-11e8-b467-0ed5f89f718b"
        case thresholdConfig = "e87a9de0-2fda-47ec-bc60-87ff31c9777f"
        case layoutConfig = "f3floi62-f54e-20e8-b467-0ed5f8hs718b"
        
        var asCBUUID: CBUUID {
            return CBUUID(string: self.rawValue)
        }
        
        
    }
}
