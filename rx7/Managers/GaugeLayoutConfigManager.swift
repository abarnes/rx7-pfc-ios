//
//  GaugeConfigManager.swift
//  rx7
//
//  Created by Austin Barnes on 10/12/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation

class GaugeLayoutConfigManager {

    static let singleton = GaugeLayoutConfigManager()
    
    struct Constants {
        static let readGaugeConfigStartingByte = UInt8(0)
        static let setGaugeConfigStartingByte = UInt8(1)
        static let separatorValue = 255
        static let separatorCount = 3
    }
    
    private let bluetoothManager = BluetoothManager.singleton
    private var gauges = [EngineDataItem]()
    private var monitors = [EngineDataItem]()
    
    func readGauges(_ completionHandler: @escaping ([EngineDataItem], [EngineDataItem]) -> Void) {
        BluetoothManager.singleton.read(characteristic: .layoutConfig) { [weak self] (data) in
            guard let `self` = self, let data = data else { return }
            
            self.parseResponse(withData: data)

            completionHandler(self.gauges, self.monitors)
        }
    }
    
    func setGauges(gauges: [EngineDataItem], monitors: [EngineDataItem], _ completionHandler: ((Bool) -> Void)?) {
        self.gauges = gauges
        self.monitors = monitors
        
        let rawData = constructData(gauges: gauges, monitors: monitors)
        bluetoothManager.write(data: rawData, forCharacteristic: BluetoothConfig.Characteristics.layoutConfig) { data in
            completionHandler?(true)
        }
        
        // TODO revise this to work
        /*
        DispatchQueue.global().after(when: 10) {
            completionHandler?(true)
        }
        */
        
    }
    
    /// MARK - Private
    
    private func parseResponse(withData data: Data) {
        guard data.count > 2 else { return }
        
        self.gauges.removeAll()
        self.monitors.removeAll()
        
        var byteIndex = 2
        var separatorCounter = 0
        var isInMonitorSection = false
        
        while (byteIndex < data.count) {
            let value = Int(data[byteIndex..<(byteIndex + 1)].to(UInt8.self))
            if (!isInMonitorSection) {
                separatorCounter = (value == Constants.separatorValue) ? (separatorCounter + 1) : 0
                
                if (separatorCounter == Constants.separatorCount) {
                    isInMonitorSection = true
                }
            }
            
            if (value != Constants.separatorValue) {
                if (!isInMonitorSection) {
                    if let item = EngineDataItem(rawValue: value) {
                        gauges.append(item)
                    }
                    byteIndex += 1
                    // let isGraphEnabled = Int(data[byteIndex..<(byteIndex + 1)].to(UInt8.self)) == 1
                    byteIndex += 1
                    // let graphTime = Int(data[byteIndex..<(byteIndex + 1)].to(UInt8.self))
                } else {
                    if let item = EngineDataItem(rawValue: value) {
                        monitors.append(item)
                    }
                }
            }
            byteIndex += 1
        }
    }
    
    private func constructData(gauges: [EngineDataItem], monitors: [EngineDataItem]) -> Data {
        var dataArray = Data(count: 0)
        
        dataArray.append(contentsOf: [Constants.setGaugeConfigStartingByte])
        dataArray.append(UInt8(0))
        
        for gauge in gauges {
            print(gauge.rawValue)
            dataArray.append(contentsOf: [UInt8(gauge.rawValue), 1, 30]) // TODO update isGraphEnabled and graphTime
        }
        
        dataArray.append(contentsOf: [UInt8.max, UInt8.max, UInt8.max])
        
        for monitor in monitors {
            print(monitor.rawValue)
            dataArray.append(contentsOf: [UInt8(monitor.rawValue)])
        }

        return dataArray
    }
    
}
