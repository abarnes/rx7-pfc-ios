//
//  AddGaugeConfigTableViewCell.swift
//  rx7
//
//  Created by Austin Barnes on 10/14/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class AddGaugeConfigTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitle(_ text: String) {
        title.text = text
    }

}
