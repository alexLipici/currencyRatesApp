//
//  SettingsVC.swift
//  Exchange
//
//  Created by Alexandru Lipici on 12/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class SettingsVC: BaseUIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currencyPicker.reloadAllComponents()
    }
    
    private func setupUI() {
        
        setCustomTitle("Settings")
        
        view.backgroundColor = .white
        
        setSegmentedControl()
        
        setCurrencyPicker()
    }
    
    private func setSegmentedControl() {
        
        segmentedControl.removeAllSegments()
        
        for (index, value) in refreshRatesValues.enumerated() {
            
            segmentedControl.insertSegment(withTitle: String(value),
                                           at: index,
                                           animated: false)
        }
        
        let currentRefreshValue = CurrencyRatesViewModel.shared.refreshTimeInterval
        
        if let indexOfCurrentRefreshInterval =
            refreshRatesValues.firstIndex(of: currentRefreshValue),
            indexOfCurrentRefreshInterval < segmentedControl.numberOfSegments{
            
            segmentedControl.selectedSegmentIndex = indexOfCurrentRefreshInterval
        }
        
        segmentedControl.addTarget(self,
                                   action: #selector(handleSegmentedControlValueChange),
                                   for: .valueChanged)
    }
    
    @objc private func handleSegmentedControlValueChange() {
        
        CurrencyRatesViewModel.shared.refreshTimeInterval =
            refreshRatesValues[segmentedControl.selectedSegmentIndex]
    }
    
    private func setCurrencyPicker() {
        
        let currencyVM = CurrencyRatesViewModel.shared
        
        let currentCurency = currencyVM.currentCurrency ?? "EUR"
                
        if let indexOfCurrentCurency = currencyVM.currencies
            .firstIndex(of: currentCurency) {
                        
            currencyPicker.selectRow(indexOfCurrentCurency,
                                     inComponent: 0,
                                     animated: false)
            
        } else if !currencyVM.currencies.isEmpty {
            
            currencyPicker.selectRow(0,
                                     inComponent: 0,
                                     animated: false)
        }
        
        currencyPicker.reloadAllComponents()
        
    }
}

extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return CurrencyRatesViewModel.shared.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard row < CurrencyRatesViewModel.shared.currencies.count else { return nil }
        
        return CurrencyRatesViewModel.shared.currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard row < CurrencyRatesViewModel.shared.currencies.count else { return }
        
        CurrencyRatesViewModel.shared.currentCurrency =
            CurrencyRatesViewModel.shared.currencies[row]
    }
}
