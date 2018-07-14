//
//  RandomStringGenerator.swit.swift
//  rx7
//
//  Created by Austin Barnes on 7/10/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

class RandomStringGenerator {
    class func generate(length: Int = 6) -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
