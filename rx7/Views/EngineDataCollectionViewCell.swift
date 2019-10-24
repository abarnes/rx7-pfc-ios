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
            setupObservers()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // setupBorders()
        setupChart()
        styleChart()
    }

    
    private func setupObservers() {
        guard let viewModel = viewModel else { return }
        
        disposeBag.dispose()
        viewModel.value.observeNext { [weak self] value in
            guard let `self` = self else { return }
            self.value.text = "\(value)"
        }.dispose(in: disposeBag)
    }
    
    private func setupBorders() {
        let gray: UIColor = .gray
        self.layer.borderColor = gray.cgColor
        self.layer.borderWidth = 3
    }
    
    private func setupChart() {
        let point1 = ChartDataEntry(x: 1, y: 15)
        let point2 = ChartDataEntry(x: 3, y: 38)
        let point3 = ChartDataEntry(x: 4, y: 25)
        
        let dataset = LineChartDataSet(entries: [point1, point2, point3], label: "")
        dataset.drawCirclesEnabled = false
        dataset.mode = .cubicBezier
        dataset.setColor(.green)
        dataset.drawFilledEnabled = true
        dataset.fillColor = .green
        
        let data = LineChartData()
        data.addDataSet(dataset)
        
        chartView.data = data
    }
    
    private func styleChart() {
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
