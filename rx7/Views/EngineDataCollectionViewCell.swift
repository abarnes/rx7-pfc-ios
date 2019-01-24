//
//  EngineDataCollectionViewCell.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit
import ReactiveKit

class EngineDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private var disposeBag = DisposeBag()
    
    var viewModel: EngineDataCollectionViewCellViewModel? {
        didSet {
            title.text = viewModel?.title
            setupObservers()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        disposeBag.dispose()
        viewModel.value.observeNext { [weak self] value in
            guard let `self` = self else { return }
            // self.value.text = "\(value)"
        }.dispose(in: disposeBag)
    }
    
}
