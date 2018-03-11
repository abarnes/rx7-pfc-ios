//
//  GpsManager.swift
//  PowerFCiOS
//
//  Created by Austin Barnes on 2/24/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import CoreLocation

class GpsManager: NSObject {
    
    static let singleton = GpsManager()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        print("initialized!")
    }
    
}

extension GpsManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            print("locations = \(location.latitude) \(location.longitude)")
        }
    }
    
}

