//
//  AddGaugeConfigViewController.swift
//  rx7
//
//  Created by Austin Barnes on 10/14/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class AddGaugeConfigViewController: UITableViewController {

    struct Constants {
        static let cellReuseIdentifier = "addGaugeConfigCell"
    }
    
    var addItemCallback: ((EngineDataItem) -> Void)?

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EngineDataItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? AddGaugeConfigTableViewCell else {
            fatalError("Failed to dequeue cell")
        }

        if let dataItem = EngineDataItem(rawValue: indexPath.row) {
            cell.setTitle(dataItem.title)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath.row < EngineDataItem.count), let item = EngineDataItem(rawValue: indexPath.row) else { return }
        
        self.addItemCallback?(item)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
