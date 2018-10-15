//
//  GaugeConfigViewController.swift
//  rx7
//
//  Created by Austin Barnes on 10/12/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit
import ReactiveKit

class GaugeConfigViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Constants {
        static let cellNibName = "GaugeConfigTableViewCell"
        static let gaugeConfigCellReuseIdentifier = "guageConfigCell"
        static let headerNibName = "GaugeConfigTableHeaderCell"
        static let headerReuseIdentifier = "gaugeConfigHeaderCell"
        static let gaugesHeaderText = "Gauges"
        static let monitorsHeaderText = "Monitors"
        static let tableHeaderHeight = 36
        static let addGaugeStoryboardFileName = "AddGaugeConfig"
        static let addGaugeStoryboardId = "AddGaugeConfigViewController"
    }
    
    var viewModel: GaugeConfigViewControllerViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.gaugeConfigCellReuseIdentifier)
        tableView.register(UINib(nibName: Constants.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.headerReuseIdentifier)
        
        setupObservers()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: true)
    }

}
/// MARK: - UITableViewDatasource

extension GaugeConfigViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return section == 0 ? (viewModel.gauges.value.count + 1) : (viewModel.monitors.value.count + 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.gaugeConfigCellReuseIdentifier, for: indexPath) as? GaugeConfigTableViewCell else {
            fatalError("Failed to dequeue cell")
        }

        if let item = viewModel?.getItem(withIndexPath: indexPath) {
            cell.setTitle(item.title)
        } else {
            cell.setIsAddButton(true)
        }
        
        return cell
    }
    
}

/// MARK - UITableViewDelegate

extension GaugeConfigViewController: UITableViewDelegate {

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            viewModel?.deleteItem(withIndexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        viewModel?.moveItem(fromIndexPath: fromIndexPath, toIndexPath: to)
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerReuseIdentifier) as? GaugeConfigTableHeaderCell else {
            fatalError("Failed to dequeue cell")
        }
        
        cell.setTitle(((section == 0) ? Constants.gaugesHeaderText : Constants.monitorsHeaderText))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.tableHeaderHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, viewModel.isAddButton(at: indexPath) else { return }
        
        let storyboard = UIStoryboard(name: Constants.addGaugeStoryboardFileName, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: Constants.addGaugeStoryboardId) as? AddGaugeConfigViewController else { return }

        controller.addItemCallback = { [weak self] item in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
                self?.viewModel?.addItem(item, toSection: indexPath.section)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

/// MARK - Private methods

extension GaugeConfigViewController {
    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        disposeBag.dispose()
        viewModel.hasLoaded.observeNext { [weak self] _ in
            self?.tableView.reloadData()
        }.dispose(in: disposeBag)
        
    }

}
