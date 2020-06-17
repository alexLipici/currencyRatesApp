//
//  HistoryVC.swift
//  Exchange
//
//  Created by Alexandru Lipici on 12/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Charts

class HistoryVC: BaseUIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: BarChartView!
    
    private lazy var viewModel = HistoryViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.actionsDelegate = self
        viewModel.getHistory()
        
        setupUI()
    }
    
    private func setupUI() {
        
        setCustomTitle("History")
        
        view.backgroundColor = .white
        
        segmentedControl.removeAllSegments()
        
        for (index, currency) in viewModel.currenciesToShow.enumerated() {
            
            segmentedControl.insertSegment(withTitle: currency,
                                           at: index,
                                           animated: false)
        }
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self,
                                   action: #selector(handleSegmentedControlAction),
                                   for: .valueChanged)
        
        viewModel.currentCurrency = viewModel.currenciesToShow[0]
    }
    
    @objc func handleSegmentedControlAction() {
        
        viewModel.currentCurrency =
            viewModel.currenciesToShow[segmentedControl.selectedSegmentIndex]
        
        guard let selectedCurrency = viewModel.currentCurrency else { return }
            
        populateGraphFor(currency: selectedCurrency)
    }
    
    private func populateGraphFor(currency: String) {
        
        var barChartDataSet: [BarChartDataSet] = []
        
        for (index, entry) in (viewModel.historyRates?[currency] ?? []).enumerated() {
            
            let barDataEntry = BarChartDataEntry(x: Double(index),
                                                 y: entry.yValue)
            
            let barDataSet = BarChartDataSet(entries: [barDataEntry],
                                             label: entry.xValue)
            barDataSet.setColor(.random())
            
            barChartDataSet.append(barDataSet)
        }
        
        let barChartData = BarChartData(dataSets: barChartDataSet)
        barChartData.setValueFont(.systemFont(ofSize: 10, weight: .light))
        
        // specify the width each bar should have
        barChartData.barWidth = 0.5
                
        chartView.data = barChartData
    }
}

extension HistoryVC: CurrencyRatesVMActionsProtocol {
    
    func networkConnectivityChanged(isConnected: Bool) {}
    
    func updateUI() {}
    
    func startedFetchingRates() {}
    
    func finishedFetchingRates() {
              
        handleSegmentedControlAction()
    }
}


