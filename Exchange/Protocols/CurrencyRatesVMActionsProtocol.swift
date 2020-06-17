//
//  CurrencyRatesVMActionsProtocol.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

/// Protocol used to make UI changes from View Model
protocol CurrencyRatesVMActionsProtocol: class {
    
    func startedFetchingRates()
    func finishedFetchingRates()
    func updateUI()
    func networkConnectivityChanged(isConnected: Bool)
}
