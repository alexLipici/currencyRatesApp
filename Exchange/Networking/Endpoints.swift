//
//  Endpoints.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct Endpoints {
    
    static var BaseRates: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_RATES_ENDPOINT") as! String
    }
    
    static var LatestRates: String {
        return String(format: "%@/latest", Endpoints.BaseRates)
    }
    
    static func LatestRates(currency: String) -> String {
        return String(format: "%@?base=%@", Endpoints.LatestRates, currency)
    }
    
    static func HistoryRates(rates: [String], startDate: Date, endDate: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let mappedRates = rates.joined(separator: ",")
        
        return String(format: "%@/history?start_at=%@&end_at=%@&symbols=%@",
                      Endpoints.BaseRates,
                      dateFormatter.string(from: startDate),
                      dateFormatter.string(from: endDate),
                      mappedRates)
    }
}
