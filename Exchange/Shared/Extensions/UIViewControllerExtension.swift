//
//  UIViewControllerExtension.swift
//  Exchange
//
//  Created by Alexandru Lipici on 12/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func topViewController() -> UIViewController? {
        return topViewControllerWith(self)
    }
    
    /// Returns top view controller
    private func topViewControllerWith(_ rootVC: UIViewController) -> UIViewController? {
        
        if rootVC is UITabBarController {
            
            let tabBarController = rootVC as! UITabBarController
            return self.topViewControllerWith(tabBarController.selectedViewController!)
            
        } else if rootVC is UISplitViewController {
            
            let splitViewController = rootVC as! UISplitViewController
            return self.topViewControllerWith(splitViewController.viewControllers[1])
            
        } else if rootVC is UINavigationController {
            
            let navigationController = rootVC as! UINavigationController
            return self.topViewControllerWith(navigationController.visibleViewController!)
            
        } else if let presentedVC = rootVC.presentedViewController {
            
            return self.topViewControllerWith(presentedVC)
            
        } else {
            
            return rootVC
        }
    }
}
