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
        setupBorders()
        setupChart()
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
        let point2 = ChartDataEntry(x: 4, y: 25)
        
        let dataset = LineChartDataSet(entries: [point1, point2], label: "")
        
        let data = LineChartData()
        data.addDataSet(dataset)
        
        chartView.data = data
    }
    
}
