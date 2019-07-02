//
//  GaugeConfigViewControllerViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 10/12/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import Bond

class GaugeConfigViewControllerViewModel {
    
    private let gaugeConfigManager = GaugeLayoutConfigManager.singleton
    
    private(set) var hasLoaded = Observable<Bool>(false)
    private(set) var isSaving = Observable<Bool>(false)
    private(set) var saveError = Observable<String?>(nil)
    
    private(set) var gauges = Observable<[EngineDataItem]>([])
    private(set) var monitors = Observable<[EngineDataItem]>([])
    
    private(set) var configHasChanged = Observable<Bool>(false)
    
    init() {
        gaugeConfigManager.readGauges { [weak self] (gauges, monitors) in
            guard let `self` = self else { return }

            self.gauges.send(gauges)
            self.monitors.send(monitors)
            self.hasLoaded.send(true)
        }
    }
    
    func getItem(withIndexPath indexPath: IndexPath) -> EngineDataItem? {
        if (indexPath.section == 0 && indexPath.row < gauges.value.count) {
            return gauges.value[indexPath.row]
        } else if (indexPath.section == 1 && indexPath.row < monitors.value.count) {
            return monitors.value[indexPath.row]
        }
        return nil
    }
    
    func addItem(_ item: EngineDataItem, toSection section: Int) {
        if (section == 0) {
            var updatedArray = gauges.value
            updatedArray.append(item)
            gauges.send(updatedArray)
        } else if (section == 1) {
            var updatedArray = monitors.value
            updatedArray.append(item)
            monitors.send(updatedArray)
        }
        
        gaugeConfigChanged()
    }
    
    func deleteItem(withIndexPath indexPath: IndexPath) {
        if (indexPath.section == 0) {
            guard (indexPath.row < gauges.value.count) else { return }
            
            var updatedGauges = gauges.value
            updatedGauges.remove(at: indexPath.row)
            gauges.send(updatedGauges)
        } else if (indexPath.section == 0) {
            guard (indexPath.row < monitors.value.count) else { return }
            
            var updatedMonitors = monitors.value
            updatedMonitors.remove(at: indexPath.row)
            monitors.send(updatedMonitors)
        }
        
        gaugeConfigChanged()
    }
    
    func moveItem(fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        if (fromIndexPath.section == 0 && toIndexPath.section == 0) {
            var updatedGauges = gauges.value
            let movedItem = updatedGauges.remove(at: fromIndexPath.row)
            updatedGauges.insert(movedItem, at: toIndexPath.row)
            gauges.send(updatedGauges)
        } else if (fromIndexPath.section == 1 && toIndexPath.section == 1) {
            var updatedMonitors = monitors.value
            let movedItem = updatedMonitors.remove(at: fromIndexPath.row)
            updatedMonitors.insert(movedItem, at: toIndexPath.row)
            monitors.send(updatedMonitors)
        } else {
            var fromArray = fromIndexPath.section == 0 ? gauges.value : monitors.value
            var toArray = toIndexPath.section == 0 ? gauges.value : monitors.value
            
            let movedItem = fromArray.remove(at: fromIndexPath.row)
            toArray.insert(movedItem, at: toIndexPath.row)

            if (toIndexPath.section == 0) {
                gauges.send(toArray)
                monitors.send(fromArray)
            } else if (toIndexPath.section == 1) {
                monitors.send(toArray)
                gauges.send(fromArray)
            }
        }
        
        gaugeConfigChanged()
    }
    
    func isAddButton(at indexPath: IndexPath) -> Bool {
        return (((indexPath.section == 0) && (indexPath.row == gauges.value.count)) || ((indexPath.section == 1) && (indexPath.row == monitors.value.count)))
    }
    
    func save() {
        guard configHasChanged.value else { return }
        
        isSaving.send(true)
        
        gaugeConfigManager.setGauges(gauges: gauges.value, monitors: monitors.value) { [weak self] (wasSuccessful) in
            guard let `self` = self else { return }
            if (!wasSuccessful) {
                self.saveError.send("Error saving gauge config.")
            } else if (self.saveError.value != nil) {
                self.saveError.send(nil)
            }
            
            self.configHasChanged.send(false)
            self.isSaving.send(false)
        }
    }
    
    /// Private Methods
    
    private func gaugeConfigChanged() {
        configHasChanged.send(true)
    }
    
    
    
}
