//
//  BluetoothConfig.swift
//  rx7
//
//  Created by Austin Barnes on 3/8/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

struct BluetoothConfig {
    
    struct Services {
        static let service = "f9d53a38-2324-11e8-b467-0ed5f89f718b"
    }
    
    struct Characteristics {
        static let deviceLoad = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb10"
        static let engineData = "f3f94f62-234e-11e8-b467-0ed5f89f718b"
    }
}
