//
//  EmptyView.swift
//  Exchange
//
//  Created by Alexandru Lipici on 11/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

/// Generic View used to fullfill some states (e.g.: fetching progress into a table view)
class EmptyView: UIView {
    
    lazy var descriptionLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .white
    }
    
    func setWith(description text: String) {
        
        addLabelIfNeeded()
        
        descriptionLabel.text = text
    }
    
    private func addLabelIfNeeded() {
        
        guard !self.subviews.contains(descriptionLabel) else { return }
        
        addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0)
        ])
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 14.0)
    }
}
