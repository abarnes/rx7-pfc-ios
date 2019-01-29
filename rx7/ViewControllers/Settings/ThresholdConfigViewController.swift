//
//  ThresholdConfigViewController.swift
//  rx7
//
//  Created by Austin Barnes on 4/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit

class ThresholdConfigViewController: UITableViewController {

    struct Constants {
        static let cellNibName = "ThresholdConfigTableViewCell"
        static let thresholdConfigTableCellIdentifier = "thresholdConfigCell"
        static let editThresholdStoryboardFileName = "EditThreshold"
        static let editThresholdStoryboardId = "EditThresholdViewController"
        static let rowHeight = 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.thresholdConfigTableCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BluetoothManager.singleton.read(characteristic: BluetoothConfig.Characteristics.thresholdConfig) { (data) in
            print("it's data \(data))")
        }
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

/// Datasource

extension ThresholdConfigViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EngineDataItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.thresholdConfigTableCellIdentifier, for: indexPath) as? ThresholdConfigTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        
        guard indexPath.row < EngineDataItem.count else { return cell }
        if let dataItem = EngineDataItem(rawValue: indexPath.row) {
            let viewModel = ThresholdConfigTableViewCellViewModel(dataItem: dataItem)
            cell.viewModel = viewModel
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: Constants.rowHeight)
    }
    
}

/// Delegate

extension ThresholdConfigViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < EngineDataItem.count else { return }
        if let dataItem = EngineDataItem(rawValue: indexPath.row) {
            let storyboard = UIStoryboard(name: Constants.editThresholdStoryboardFileName, bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.editThresholdStoryboardId) as? EditThresholdViewController else { return }
            
            ThresholdConfigManager.singleton.getThreshold(for: dataItem) { (threshold) in
                guard let threshold = threshold else {
                    // TODO show an error
                    return
                }
                
                controller.viewModel = EditThresholdViewControllerViewModel(dataItem: dataItem, threshold: threshold, parameters: dataItem.editThresholdParameters)
                self.navigationController?.pushViewController(controller, animated: true)
            }
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
