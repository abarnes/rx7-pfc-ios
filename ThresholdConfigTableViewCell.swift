//
//  ThresholdConfigTableViewCell.swift
//  rx7
//
//  Created by Austin Barnes on 4/16/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class ThresholdConfigTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: ThresholdConfigTableViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            title.text = viewModel.title
            warningLabel.text = viewModel.warningValue
            errorLabel.text = viewModel.criticalValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
