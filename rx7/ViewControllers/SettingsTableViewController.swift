//
//  SettingsTableViewController.swift
//  rx7
//
//  Created by Austin Barnes on 3/15/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

private enum SettingsSections: String {
    case gauges = "Gauges"
    case thresholds = "Thresholds"
    case requestIntervals = "Intervals"
}

class SettingsTableViewController: UITableViewController {

    struct Constants {
        static let settingsTableCellIdentifier = "SettingsTableViewCell"
        static let thresholdConfigStoryboardFileName = "ThresholdConfig"
        static let thresholdConfigStoryboardId = "ThresholdConfigViewController"
        static let gaugeConfigStoryboardFileName = "GaugeConfig"
        static let gaugeConfigStoryboardId = "GaugeConfigViewController"
        static let cellNibName = "SettingsTableViewCell"
        
    }
    
    fileprivate let settingsLinkArray: [SettingsSections] = [.gauges, .thresholds, .requestIntervals]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.settingsTableCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/// Datasource

extension SettingsTableViewController {
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsLinkArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingsTableCellIdentifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        guard indexPath.row < settingsLinkArray.count else { return cell }
        let selectedSettingsSection = settingsLinkArray[indexPath.row]
        cell.setTitle(selectedSettingsSection.rawValue)

        return cell
    }

}

/// Delegate

extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < settingsLinkArray.count else { return }
        let selectedSettingsSection = settingsLinkArray[indexPath.row]
        
        switch selectedSettingsSection {
        case .gauges:
            let storyboard = UIStoryboard(name: Constants.gaugeConfigStoryboardFileName, bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.gaugeConfigStoryboardId) as? GaugeConfigViewController else { return }
            controller.viewModel = GaugeConfigViewControllerViewModel()
            self.navigationController?.pushViewController(controller, animated: true)
        case .thresholds:
            let storyboard = UIStoryboard(name: Constants.thresholdConfigStoryboardFileName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: Constants.thresholdConfigStoryboardId)
            self.navigationController?.pushViewController(controller, animated: true)
        case .requestIntervals:
            print("requestIntervals")
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
