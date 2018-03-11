//
//  EngineDataViewController.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit
import ReactiveKit

class EngineDataViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lagLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    fileprivate struct Constants {
        static let engineDataCollectionViewCellIdentifier = "engineDataCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupObservers() {
        disposeBag.dispose()
        EngineDataStateManager.singleton.current.observeNext { [weak self] (engineData) in
            guard let engineData = engineData else { return }
            
            let currentTime = Int(Date().timeIntervalSince1970 * 1000)
            var estimatedLag = (currentTime - engineData.time)
            if (estimatedLag < 0) {
                estimatedLag = 0
            }
            
            self?.lagLabel.text = "Est. Lag: \(estimatedLag)ms"
        }.dispose(in: disposeBag)
    }
    
}

extension EngineDataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GaugeType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.engineDataCollectionViewCellIdentifier, for: indexPath) as? EngineDataCollectionViewCell else {
            fatalError("Could not cast cell to EngineDataCollectionViewCell")
        }
        
        if let gauge = GaugeType(rawValue: indexPath.row) {
            cell.viewModel = EngineDataCollectionViewCellViewModel(gauge: gauge)
        }
        
        return cell
    }
    
}
