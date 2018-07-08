//
//  EngineDataCollectionViewCellViewModel.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class EngineDataCollectionViewCellViewModel {
    
    var disposeBag = DisposeBag()
    private(set) var title: String
    private(set) var value = Observable<String>("")
    
    init(gauge: EngineDataItem) {
        title = gauge.title
        
        setupObservers(forKey: gauge)
    }
    
    private func setupObservers(forKey key: EngineDataItem) {
        EngineDataStateManager.singleton.current.observeNext { [weak self] (engineData) in
            guard let engineData = engineData else { return }
            
            switch key {
            case .rpm:
                self?.value.next("\(engineData.rpm)")
            case .boost:
                self?.value.next("\(engineData.boost)")
            case .waterTemp:
                self?.value.next("\(engineData.waterTemp)")
            case .knock:
                self?.value.next("\(engineData.knock)")
            case .injectorDuty:
                self?.value.next("\(engineData.injectorDuty)")
            case .leadingIgnition:
                self?.value.next("\(engineData.leadingIgnition)")
            case .trailingIgnition:
                self?.value.next("\(engineData.trailingIgnition)")
            case .speed:
                self?.value.next("\(engineData.speed)")
            case .airTemp:
                self?.value.next("\(engineData.airTemp)")
            case .batteryVoltage:
                self?.value.next("\(engineData.batteryVoltage)")
            case .intakePressure:
                self?.value.next("\(engineData.intakePressure)")
            case .mapSensorVoltage:
                self?.value.next("\(engineData.mapSensorVoltage)")
            case .tpsVoltage:
                self?.value.next("\(engineData.tpsVoltage)")
            case .primaryInjectorPulse:
                self?.value.next("\(engineData.primaryInjectorPulse)")
            case .fuelCorrection:
                self?.value.next("\(engineData.fuelCorrection)")
            case .fuelTemp:
                self?.value.next("\(engineData.fuelTemp)")
            case .mopPosition:
                self?.value.next("\(engineData.mopPosition)")
            case .boostTP:
                self?.value.next("\(engineData.boostTP)")
            case .boostWG:
                self?.value.next("\(engineData.boostWG)")
            case .intakeTemp:
                self?.value.next("\(engineData.intakeTemp)")
            case .iscvDuty:
                self?.value.next("\(engineData.iscvDuty)")
            case .o2Voltage:
                self?.value.next("\(engineData.o2Voltage)")
            case .secondaryInjectorPulse:
                self?.value.next("\(engineData.secondaryInjectorPulse)")
            case .tpsFullRangeVoltage:
                self?.value.next("\(engineData.rpm)")
            case .tpsNarrowRangeVoltage:
                self?.value.next("\(engineData.rpm)")
            case .mopPositionSensorVoltage:
                self?.value.next("\(engineData.rpm)")
            case .waterTempSensorVoltage:
                self?.value.next("\(engineData.rpm)")
            case .intakeAirTempSensorVoltage:
                self?.value.next("\(engineData.rpm)")
            case .fuelTempSensorVoltage:
                self?.value.next("\(engineData.rpm)")
            case .o2SensorVoltage:
                self?.value.next("\(engineData.rpm)")
            case .starterSwitch:
                self?.value.next("\(engineData.rpm)")
            case .airConditioningSwitch:
                self?.value.next("\(engineData.rpm)")
            case .powerSteeringPressureSwitch:
                self?.value.next("\(engineData.rpm)")
            case .neutralSwitch:
                self?.value.next("\(engineData.rpm)")
            case .clutchSwitch:
                self?.value.next("\(engineData.rpm)")
            case .stopSwitch:
                self?.value.next("\(engineData.rpm)")
            case .catalyzerThermoSensorSwitch:
                self?.value.next("\(engineData.rpm)")
            case .electricalLoadSwitch:
                self?.value.next("\(engineData.rpm)")
            case .exhaustTempWarningIndicator:
                self?.value.next("\(engineData.rpm)")
            case .fuelPumpOperation:
                self?.value.next("\(engineData.rpm)")
            case .fuelPumpControl:
                self?.value.next("\(engineData.rpm)")
            case .airPumpRelay:
                self?.value.next("\(engineData.rpm)")
            case .portAirControl:
                self?.value.next("\(engineData.rpm)")
            case .chargeControl:
                self?.value.next("\(engineData.rpm)")
            case .turboControl:
                self?.value.next("\(engineData.rpm)")
            case .pressureRegulatorControl:
                self?.value.next("\(engineData.rpm)")
            }
        }.dispose(in: disposeBag)
    }
    
}
