//
//  EditThresholdViewController.swift
//  rx7
//
//  Created by Austin Barnes on 4/16/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class EditThresholdViewController: UIViewController {

    @IBOutlet weak var warningEditor: EditThresholdView!
    @IBOutlet weak var criticalEditor: EditThresholdView!
    
    var viewModel: EditThresholdViewControllerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = viewModel else { return }
        
        warningEditor.viewModel = EditThresholdViewModel(type: .warning, value: viewModel.currentValue.warning, editParameters: viewModel.editParameters)
        criticalEditor.viewModel = EditThresholdViewModel(type: .critical, value: viewModel.currentValue.critical, editParameters: viewModel.editParameters)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
