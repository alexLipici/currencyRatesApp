//
//  HistoryCurrencyModel.swift
//  Exchange
//
//  Created by Alexandru Lipici on 12/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

struct HistoryCurrencyModel: Decodable {
    
    var daysRates: [String : [String: Double]] = [:]
    var startDate: String?
    var endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case daysRates = "rates"
        case startDate = "start_at"
        case endDate = "end_at"
    }
}

struct ChartModel {
    var xValue: String
    var yValue: Double
}
