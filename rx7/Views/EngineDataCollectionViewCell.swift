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
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    
    var viewModel: EngineDataCollectionViewCellViewModel? {
        didSet {
            title.text = viewModel?.title
            setupObservers()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
    }
    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        disposeBag.dispose()
        viewModel.value.observeNext { [weak self] value in
            self?.value.text = value
        }.dispose(in: disposeBag)
    }
    
}
