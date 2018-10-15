//
//  GaugeConfigTableViewCell.swift
//  rx7
//
//  Created by Austin Barnes on 10/13/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class GaugeConfigTableViewCell: UITableViewCell {

    @IBOutlet weak var gaugeName: UILabel!
    
    struct Constants {
        static let addText = " Add item +"
        static let addColor = UIColor.init(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(_ title: String) {
        gaugeName.text = title
    }
    
    func setIsAddButton(_ isAddButton: Bool) {
        guard isAddButton else { return }
        
        gaugeName.text = Constants.addText
        gaugeName.textColor = Constants.addColor
    }
    
}
