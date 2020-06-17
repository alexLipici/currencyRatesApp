//
//  HistoryViewModel.swift
//  Exchange
//
//  Created by Alexandru Lipici on 12/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class HistoryViewModel: HistoryVMProtocol {
    
    ///Keep ViewModel into a singleton instance
    private static var _shared: HistoryViewModel?
    
    static var shared: HistoryViewModel {
        get {
            guard let privateShared = _shared else {
                
                _shared = HistoryViewModel()
                return _shared!
            }
            return privateShared
        }
    }
    
    final class func destroySingleton() {
        _shared = nil
    }
    
    ///Delegate used to update View
    weak var actionsDelegate: CurrencyRatesVMActionsProtocol?
    
    /// Dictionary used to store data for chart population
    lazy var historyRates: [String : [ChartModel]]? = [:]
    
    /// Array that keep currencies that wil; be displayed in the History screen
    let currenciesToShow: [String] = ["RON", "USD", "BGN"]
    
    /// Constant that keep the sample interval of history
    let chartDaysSample: Int = 10
    
    lazy var currentCurrency: String? = currenciesToShow.first
    
    private init() { }
    
    /// Method used to fetch history
    func getHistory() {
        
        actionsDelegate?.startedFetchingRates()
        
        CurrencyNetworking.getRatesHistoryFor(
            currenciesToShow,
            days: chartDaysSample) { [weak self] (rates) in
            
            self?.historyRates = rates
            self?.actionsDelegate?.finishedFetchingRates()
        }
    }
}
