//
//  FirstViewController.swift
//  rx7
//
//  Created by Austin Barnes on 3/4/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit
import ReactiveKit

class HomeViewController: UIViewController {

    @IBOutlet weak var connectionStatus: UILabel!
    
    private var disposeBag = DisposeBag()
    
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
        BluetoothManager.singleton.state.observeNext { [weak self] (state) in
            self?.connectionStatus.text = state.rawValue
        }.dispose(in: disposeBag)
    }

}

