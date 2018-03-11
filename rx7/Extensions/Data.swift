//
//  Data.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//
import Foundation

extension Data {
    
    func to<T>(_ type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
    
}
