//
//  EngineDataCollectionViewCell.swift
//  rx7
//
//  Created by Austin Barnes on 3/11/18.
//  Copyright © 2018 Austin Barnes. All rights reserved.
//

import UIKit
import ReactiveKit
import Charts

class EngineDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var chartView: LineChartView!
    
    private var disposeBag = DisposeBag()
    
    var viewModel: EngineDataCollectionViewCellViewModel? {
        didSet {
            title.text = viewModel?.title
            setupChart()
            styleChart()
            setupObservers()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleChart()
    }

    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        disposeBag.dispose()
        viewModel.value.observeNext { [weak self] value in
            guard let `self` = self else { return }
            self.value.text = "\(value)"
        }.dispose(in: disposeBag)
        
        viewModel.shouldUpdateChart.observe { [weak self] _ in
            guard let `self` = self else { return }
            
            // Both lines below are necessary for real time updating
            self.chartView.data?.notifyDataChanged()
            self.chartView.notifyDataSetChanged()
        }.dispose(in: disposeBag)
    }
    
    private func setupChart() {
        guard let dataset = viewModel?.dataset else { return }
        
        let data = LineChartData()
        data.addDataSet(dataset)
        chartView.data = data
    }
    
    private func styleChart() {
        if let dataset = viewModel?.dataset {
            dataset.drawCirclesEnabled = false
            dataset.mode = .horizontalBezier
            dataset.setColor(.green)
            dataset.drawFilledEnabled = true
            dataset.fillColor = .green
            dataset.drawValuesEnabled = false
        }
        
        chartView.backgroundColor = .white
        chartView.gridBackgroundColor = .white // UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 150/255)
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        // chartView.leftAxis.enabled = false
        chartView.leftAxis.axisLineWidth = 0
        chartView.leftAxis.gridColor = .lightGray
        chartView.leftAxis.gridLineWidth = 0.5
    }
    
}
