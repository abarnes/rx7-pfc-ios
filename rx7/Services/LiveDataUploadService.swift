//
//  LiveDataUploadService.swift
//  rx7
//
//  Created by Austin Barnes on 4/8/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import Foundation
import ReactiveKit

class LiveDataUpdateService {
    
    static let singleton = LiveDataUpdateService()
    private let disposeBag = DisposeBag()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        EngineDataStateManager.singleton.current.observeNext { [weak self] (engineData) in
            guard let `self` = self, let engineData = engineData else { return }
            self.uploadData(data: engineData)
        }.dispose(in: disposeBag)
    }
    
    private func uploadData(data: EngineDataPoint) {
        
    }
    
}
