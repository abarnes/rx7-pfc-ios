//
//  EditThresholdView.swift
//  rx7
//
//  Created by Austin Barnes on 4/21/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class EditThresholdView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    struct Constants {
        static let xibName = "EditThresholdView"
    }
    
    var viewModel: EditThresholdViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            inputField.text = "\(viewModel.currentValue)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /*
    static func initializeFromXib() -> EditThresholdView {
        guard let view = Bundle.main.loadNibNamed(Constants.xibName, owner: self, options: nil)?.first as? EditThresholdView else { return }
    }*/
    
    private func commonInit() {
        Bundle.main.loadNibNamed(Constants.xibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
