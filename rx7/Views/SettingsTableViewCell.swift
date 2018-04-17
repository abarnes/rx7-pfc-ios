//
//  SettingsTableViewCell.swift
//  rx7
//
//  Created by Austin Barnes on 4/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var link: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(_ title: String) {
        link.text = title
    }
    
}
