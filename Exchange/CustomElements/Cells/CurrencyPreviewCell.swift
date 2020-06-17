//
//  CurrencyPreviewCell.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class CurrencyPreviewCell: UITableViewCell {

    @IBOutlet weak var currencyIDLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setWith(currency: String?, value: Double?) {
        
        currencyIDLabel.text = currency
        
        if let currencyValue = value {
            currencyValueLabel.text = String(currencyValue)
        }
    }
}
