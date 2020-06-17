//
//  BaseUIViewController.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
 
class BaseUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setNavigationBarStyle()
    }
    
    func setCustomTitle(_ customTitle: String?) {

        DispatchQueue.main.async {
            self.navigationItem.title = customTitle
        }
    }
    
    ///Method that set navigation bar height depending screen size
    private func _setNavigationBarStyle() {
        
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItems = []
    }
    
    ///Method that set go back button to the left side of navigation bar
    func setNavigationBarForDismiss() {
        
        let backButtonItem =
            UIBarButtonItem(image: UIImage(named: "backButtonIcon"),
                            style: UIBarButtonItem.Style.plain,
                            target: self,
                            action: #selector(dismissAction))
        
        navigationItem.leftBarButtonItem = backButtonItem
    
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    ///Method that dismiss curent view controller depending presentation type
    @objc func dismissAction() {
        
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            
            navigationController?.popViewController(animated: true)
                        
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
