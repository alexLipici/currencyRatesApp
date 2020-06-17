//
//  CurrencyNetworking.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Alamofire

/// Class that take care of http requests
class CurrencyNetworking {
    
    typealias completionRates = ([RateModel]?)->Void
    typealias completionHistoryRates = ([String : [ChartModel]]?)->Void
    
    // Flag used to avoid multiple request to the same Rates endpoint
    private static var isFetchingRates: Bool = false
    
    // Variable used to store a http request, in order to cancel it if needed
    private static var getRatesRequest: DataRequest? = nil
    
    /// Method used to get the latest rates of a selected currency
    ///
    /// - Parameters:
    ///     - currency: a string value that set the currency
    ///     - completion: completion block used to return an array of rates to caller method
    ///
    static func getRates(currency: String?, completion: @escaping completionRates) {
        
        // if a similar call is in progress, cancel the new one
        guard !isFetchingRates else { return }
        
        isFetchingRates = true
        
        let currencyToFetch = currency ?? "EUR"
        
        getRatesRequest = Alamofire.request(Endpoints.LatestRates(
            currency: currencyToFetch)).responseJSON { response in
            
            isFetchingRates = false
            
            switch response.result {
                
            case .failure(let error):
                
                print("Request error:", error)
                
                completion(nil)

            case .success:
                
                guard let responseData = response.data else {
                        
                    completion(nil)
                    return
                }
                
                do {
                    //received data will be decoded using a Decodable model
                    let model = try JSONDecoder().decode(CurrencyModel.self,
                                                         from: responseData)
                    
                    completion(parseRatesDictionary(model.rates))
                    
                } catch let err {
                    
                    print("Error decoding request response:", err)
                    completion(nil)
                }
            }
        }
    }
    
    /// Method used to convert rates dictionary from response
    ///  to an array of custom model rates. Method will return an ordered array (ordered by currency name)
    ///
    /// - Parameters:
    ///     - dictionary: a dictionary that will be parsed by the method
    ///
    private static func parseRatesDictionary(_ dictionary: [String : Double]) -> [RateModel] {
        
        var rates = [RateModel]()
        
        for (key, value) in dictionary {
            
            rates.append(RateModel(currency: key, value: value))
        }
        
        return rates.sorted(by: {$0.currency < $1.currency})
    }
    
    /// Method used to cancel a running request
    ///
    static func cancelGetRatesRequest() {
        
        getRatesRequest?.cancel()
    }
    
    /// Method used to retrieve rates history fot the latest days received by parameter
    ///
    /// - Parameters:
    ///     - rates: an array used to define the rates that should be included in get call
    ///     - days: an integer used to set the time interval for history
    ///     - completion: completion block used to return a dictionary ({"EUR" : [ChartModel], "USD" : [ChartModel]})
    ///
    static func getRatesHistoryFor(_ rates: [String],
                                   days: Int,
                                   completion: @escaping completionHistoryRates) {
        
        let currentDate = Date()
        
        guard let startDate = getStartDateFor(endDate: currentDate, days: days) else {
            completion(nil)
            return
        }
                
        Alamofire.request(Endpoints.HistoryRates(rates: rates,
                                                 startDate: startDate,
                                                 endDate: currentDate)).responseJSON { response in
                        
            switch response.result {
                
            case .failure(let error):
                
                print("Request error:", error)
                
                completion(nil)

            case .success:
                
                guard let responseData = response.data else {
                        
                    completion(nil)
                    return
                }
                
                do {
                    
                    let model = try JSONDecoder().decode(HistoryCurrencyModel.self,
                                                         from: responseData)
                    
                    print("Model:", model)
                    
                    completion(parseRatesHistoryModel(model))
                    
                } catch let err {
                    
                    print("Error decoding request response:", err)
                    completion(nil)
                }
            }
        }
    }
    
    /// Method used to parse the response from getRatesHistoryFor(_:, :, :) method
    /// It split the HistoryCurrencyModel into a dictionary of currencies. Each currency has
    /// an array of ChartModel (chart model has data of date and currency value)
    ///
    private static func parseRatesHistoryModel(_ model: HistoryCurrencyModel) -> [String : [ChartModel]]? {
               
        var currencies = [String : [ChartModel]]()
        
        for (date, rate) in model.daysRates {
            
            for (currency, value) in rate {
        
                let chartModel = ChartModel(xValue: date, yValue: value)
                
                if currencies[currency] == nil {
                    currencies[currency] = []
                }
                
                currencies[currency]?.append(chartModel)
            }
        }
        
        for (currency, _) in currencies {
            currencies[currency] = currencies[currency]?.sorted(by: {$0.xValue < $1.xValue})
        }
                        
        return currencies
    }
    
    /// Method used to get the start date from a defined endDate and days to go back in time
    ///
    private static func getStartDateFor(endDate: Date, days: Int) -> Date? {
        
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: endDate)
        
        let startDate = calendar.date(byAdding: .day,
                                      value: -days,
                                      to: currentDate)
        
        return startDate
    }
}
