//
//  HistoryVMProtocol.swift
//  Exchange
//
//  Created by Alexandru Lipici on 17/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

/// Mandatory methods that should be implemented by History View Model
protocol HistoryVMProtocol: class {
    
    func getHistory()
}
