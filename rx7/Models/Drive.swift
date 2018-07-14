//
//  Drive.swift
//  rx7
//
//  Created by Austin Barnes on 7/10/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Drive {
    
    private(set) var code: String
    private(set) var isLive: Bool
    private(set) var start: Date
    private(set) var end: Date?
    
    init(code: String, start: Date, isLive: Bool = true) {
        self.code = code
        self.start = start
        self.isLive = isLive
    }
    
    mutating func endDrive(atTime time: Date) {
        self.end = time
    }
    
    func convertToFirestoreData() -> [String: Any] {
        let end = (self.end != nil) ? self.end! : nil
        
        return [
            "code": self.code,
            "start": self.start,
            "end": end,
            "isLive": self.isLive
        ]
    }
    
}
