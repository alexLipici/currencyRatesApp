//
//  ConectivityManager.swift
//  Exchange
//
//  Created by Alexandru Lipici on 17/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Alamofire

/// Manager used to check network connectivity.
/// It uses Alamofire reachibility implementation
class ConectivityManager {
    
    typealias NetworkReachabilityStatus =
        NetworkReachabilityManager.NetworkReachabilityStatus
    
    static let shared = ConectivityManager()
        
    private let reachabilityManager = NetworkReachabilityManager()
    private var reachabilityStatus: NetworkReachabilityStatus = .unknown {
        
        didSet {
            if oldValue != reachabilityStatus && oldValue != .unknown {
                
                NotificationCenter.default.post(
                    name: Notification.Name.Network.ReachabilityStateChanged,
                    object: nil)
            }
        }
    }
    
    private init() {
        
        reachabilityManager?.listener = {
            [weak self] status in
                        
            self?.reachabilityStatus = status
        }
        
        reachabilityManager?.startListening()
    }
    
    var dataNetworkAvailable: Bool {
        
        return getIfIsConnectedFor(reachabilityStatus)
    }
    
    //used mostly for network scanner to check for wifi
    var wifiNetworkAvailable: Bool {
        
        return reachabilityStatus == .reachable(.ethernetOrWiFi)
    }
    
    private func getIfIsConnectedFor(_ status: NetworkReachabilityStatus) -> Bool {
        
        if status == .unknown ||
            status == .notReachable {
            
            return false
            
        } else {
            
            return true
        }
    }
}
