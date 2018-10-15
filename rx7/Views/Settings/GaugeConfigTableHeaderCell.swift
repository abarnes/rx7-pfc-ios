//
//  GaugeConfigTableHeaderCell.swift
//  rx7
//
//  Created by Austin Barnes on 10/13/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class GaugeConfigTableHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionTitle: UILabel!
    
    func setTitle(_ title: String) {
        sectionTitle.text = title
    }

}
