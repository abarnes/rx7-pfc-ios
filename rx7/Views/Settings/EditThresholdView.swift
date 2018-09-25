//
//  EditThresholdView.swift
//  rx7
//
//  Created by Austin Barnes on 4/21/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit
import ReactiveKit

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
    
    var disposeBag = DisposeBag()
    var viewModel: EditThresholdViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            typeLabel.text = viewModel.type.rawValue.capitalized
            
            toggle.setOn(viewModel.currentEnabled.value, animated: false)
            let segment = viewModel.currentIsGreaterThan.value ? 0 : 1
            segmentedControl.setEnabled(true, forSegmentAt: segment)
            
            setInputFieldText()
            setupStepper()
            setupObservers()
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
    
    @IBAction func toggleEnabled(_ sender: UISwitch) {
        viewModel?.toggleEnabled(sender.isOn)
    }
    
    @IBAction func changeThresholdDirection(_ sender: Any) {
        viewModel?.toggleDirection(isGreaterThan: (segmentedControl.selectedSegmentIndex == 0))
    }

    @IBAction func stepperTapped(_ sender: UIStepper) {
        print(stepper.value)
        viewModel?.updateCurrentValue(sender.value)
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
    
    private func setupStepper() {
        guard let viewModel = viewModel else { return }
        
        stepper.minimumValue = viewModel.editParameters.min
        stepper.maximumValue = viewModel.editParameters.max
        stepper.stepValue = viewModel.editParameters.step
        stepper.value = viewModel.currentValue.value
    }
    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        disposeBag.dispose()
        viewModel.currentEnabled.observeNext { [weak self] (enabled) in
            self?.toggle.isOn = enabled
        }.dispose(in: disposeBag)
        
        viewModel.currentIsGreaterThan.observeNext { [weak self] (isGreaterThan) in
            self?.segmentedControl.setEnabled(true, forSegmentAt: (isGreaterThan ? 0 : 1))
        }.dispose(in: disposeBag)
        
        viewModel.currentValue.observeNext { [weak self] _ in
            self?.setInputFieldText()
        }.dispose(in: disposeBag)
    }
    
    private func setInputFieldText() {
        guard let viewModel = viewModel else { return }
        inputField.text = viewModel.editParameters.usesIntegers ? "\(Int(viewModel.currentValue.value))" : "\(viewModel.currentValue.value)"
    }

}
