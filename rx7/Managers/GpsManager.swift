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
    
    fileprivate var timestampArray = [Int]()
    fileprivate var locationArray = [CLLocationCoordinate2D]()
    
    override init() {
        super.init()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    func findLocationForTime(_ time: Int) -> CLLocationCoordinate2D? {
        guard (timestampArray.count > 0), (locationArray.count > 0) else {
            return nil
        }
        
        var foundLocation: CLLocationCoordinate2D?
        for index in (0..<timestampArray.count).reversed() {
            if (timestampArray[index] > time) {
                continue
            }
            
            foundLocation = locationArray[index]
            break
        }
        print("correlated location is \(foundLocation)")
        return foundLocation
    }
    
}

extension GpsManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            timestampArray.append(Int(Date().timeIntervalSince1970 * 1000))
            locationArray.append(location)
            
            // publish update over bluetooth
            BluetoothCentralManager.singleton.write("\(location)".data(using: .utf8)!, forCharacteristic: BluetoothConfig.Characteristics.gpsReceiver)
            
            print("locations = \(location.latitude) \(location.longitude)")
        }
    }
    
}

