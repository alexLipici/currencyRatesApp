//
//  CurrencyRatesViewModel.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Alamofire

class CurrencyRatesViewModel: CurrencyRatesVMProtocol {
    
    ///Keep ViewModel into a singleton instance
    private static var _shared: CurrencyRatesViewModel?
    
    static var shared: CurrencyRatesViewModel {
        get {
            guard let privateShared = _shared else {
                
                _shared = CurrencyRatesViewModel()
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
    
    /// Boolean value used to get network status
    var isNetworkAvailable: Bool {
        return ConectivityManager.shared.dataNetworkAvailable
    }
    
    /// Array used to keep the latest rates; didSet also will update the latest currencies
    var rates: [RateModel] = [] {
        didSet {
            currencies = rates.compactMap({ (rateModel) -> String in
                return rateModel.currency
            })
        }
    }
    
    /// Array used to keep currencies in order to change the default one (EUR)
    /// to another one from Settings tab. This data will be stored persistently
    ///
    var currencies: [String] {
        get {
            return UserDefaults.standard.array(forKey: "allCurrencies") as? [String] ?? []
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "allCurrencies")
        }
    }
    
    /// Variable used to store the current selected currency. It also will reset some data from view model
    var currentCurrency: String? {
        
        set {

            UserDefaults.standard.set(newValue,
                                      forKey: "currentCurrency")
            
            if !rates.isEmpty {
                rates.removeAll()
            }
            
            lastTimeRefreshed = nil
            
            actionsDelegate?.updateUI()
        }
        
        get {
            
            let storedCurrentCurency = UserDefaults.standard.string(
                forKey: "currentCurrency")
            
            return storedCurrentCurency
        }
    }
    
    /// Variable used to keep the date formater used by the app
    private var timeStampFormater: DateFormatter = {
        
        $0.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return $0
        
    }(DateFormatter())
    
    /// Variable used to store the last time the currency rate updated
    private var lastTimeRefreshed: Date? {
        
        didSet {
            
            refreshTimeStamp = timeStampFormater.string(from: Date())
        }
    }
    
    var refreshTimeStamp: String?
    
    /// Variable that take the reference of a timer used to refresh rates every a period of time
    private var refreshTimer: Timer?
    
    /// Variable used to store the refresh interval of rates
    var refreshTimeInterval: TimeInterval {
        
        set {
            UserDefaults.standard.set(newValue,
                                      forKey: "refreshTimeInterval")
        }
        
        get {
            
            let storedRefreshRate = UserDefaults.standard.double(
                forKey: "refreshTimeInterval")
            
            if storedRefreshRate == 0.0 {
                
                UserDefaults.standard.set(refreshRatesValues.first,
                                          forKey: "refreshTimeInterval")
                
                return refreshRatesValues.first!
            }
            
            return storedRefreshRate
        }
    }
    
    /// init method add a listener for conectivity change
    private init() {
        
        ///add observer for network change
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleReachabilityStateChanged),
            name: Notification.Name.Network.ReachabilityStateChanged,
            object: nil)
    }
    
    /// Method used to fetch rates. It also stop the previous timer
    func fetchRates() {
        
        stopRatesUpdate()
        
        getRates()
    }
    
    @objc private func getRates() {
        
        actionsDelegate?.startedFetchingRates()
        
        CurrencyNetworking.getRates(currency: currentCurrency) { [weak self] (receivedRates) in
                        
            guard let `self` = self else { return }
            
            if let rates = receivedRates {
                
                self.rates = rates
                self.lastTimeRefreshed = Date()
            }
            
            if self.refreshTimer == nil {
                
                self.refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: self.refreshTimeInterval,
                    repeats: true,
                    block: { [weak self] (timer) in
                    
                    self?.getRates()
                })
            }
            
            self.actionsDelegate?.finishedFetchingRates()
        }
    }
    
    /// Method used to stop the timer of rates get
    @objc func stopRatesUpdate() {
        
        refreshTimer?.invalidate()
        
        refreshTimer = nil
        
        CurrencyNetworking.cancelGetRatesRequest()
    }
    
    @objc private func handleReachabilityStateChanged() {
                
        actionsDelegate?.networkConnectivityChanged(
            isConnected: isNetworkAvailable)
    }
}
