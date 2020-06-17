//
//  NotificationNameExtension.swift
//  Exchange
//
//  Created by Alexandru Lipici on 17/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

extension Notification.Name {

    struct Network {
        static let ReachabilityStateChanged = Notification.Name(
            rawValue: "Network.ReachabilityStateChanged")
    }
}
