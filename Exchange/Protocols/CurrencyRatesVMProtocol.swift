//
//  CurrencyRatesVMProtocol.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

/// Mandatory methods that should be implemented by Currency Rates View Model
protocol CurrencyRatesVMProtocol: class {
    
    func fetchRates()
}
