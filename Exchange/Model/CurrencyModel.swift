//
//  CurrencyModel.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct CurrencyModel: Decodable {
    
    var rates: [String : Double] = [:]
    var baseCurrency: String?
    var date: String?
    
    enum CodingKeys: String, CodingKey {
        case rates, date
        case baseCurrency = "base"
    }
}

struct RateModel {
    var currency: String
    var value: Double
}
