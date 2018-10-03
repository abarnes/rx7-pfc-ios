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
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    fileprivate struct Constants {
        static let cellNibName = "EngineDataCollectionViewCell"
        static let engineDataCollectionViewCellIdentifier = "engineDataCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.engineDataCollectionViewCellIdentifier)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        
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
            
            self?.updateEstimatedLag(from: engineData)
            self?.updateCoordinates(from: engineData)
        }.dispose(in: disposeBag)
        
        BluetoothManager.singleton.state.observeNext { [weak self] (state) in
            self?.statusLabel.text = state.rawValue
        }.dispose(in: disposeBag)
    }
    
    private func updateEstimatedLag(from engineData: EngineDataPoint) {
        guard let dataTime = engineData.time else { return }
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        var estimatedLag = (currentTime - dataTime)
        if (estimatedLag < 0) {
            estimatedLag = 0
        }
        
        DispatchQueue.main.async { [weak self] in
             self?.lagLabel.text = "Est. Lag: \(estimatedLag)ms"
        }
    }
    
    private func updateCoordinates(from engineData: EngineDataPoint) {
        guard let location = engineData.location else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.coordinatesLabel.text = "\(location.latitude)º, \(location.longitude)º"
        }
    }
    
}

extension EngineDataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EngineDataItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.engineDataCollectionViewCellIdentifier, for: indexPath) as? EngineDataCollectionViewCell else {
            fatalError("Could not cast cell to EngineDataCollectionViewCell")
        }
        
        if let gauge = EngineDataItem(rawValue: indexPath.row) {
            cell.viewModel = EngineDataCollectionViewCellViewModel(gauge: gauge)
        }
        
        return cell
    }
    
}
