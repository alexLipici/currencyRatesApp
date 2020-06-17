//
//  UIColorExtension.swift
//  Exchange
//
//  Created by Alexandru Lipici on 12/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
