//
//  AppDelegate.swift
//  Exchange
//
//  Created by Alexandru Lipici on 10/06/2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// set tab bar
        window?.rootViewController = getTabBar()
        
        /// set navigation bar style
        setupNavigationBar()
        
        /// init the conectivity manager
        let _ = ConectivityManager.shared
        
        return true
    }
    
    func setupNavigationBar() {
        
        //update navigationBar title color
        let navigationBarAppearace = UINavigationBar.appearance()
        let navigationBarMainColor = UIColor.groupTableViewBackground
        let navigationBarTextColor = UIColor.black
        
        if #available(iOS 13.0, *) {
            
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = navigationBarMainColor
            
            appearance.titleTextAttributes = [
                .foregroundColor: navigationBarTextColor
            ]
            
            appearance.largeTitleTextAttributes = [
                .foregroundColor: navigationBarTextColor
            ]
            
            navigationBarAppearace.tintColor = navigationBarMainColor
            navigationBarAppearace.standardAppearance = appearance
            navigationBarAppearace.compactAppearance = appearance
            navigationBarAppearace.scrollEdgeAppearance = appearance
            
        } else {
            
            navigationBarAppearace.titleTextAttributes = [
                .foregroundColor: navigationBarTextColor
            ]
            navigationBarAppearace.backgroundColor = navigationBarMainColor
        }
    }
    
    func getTabBar() -> UITabBarController {
        
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "kTabBarNVC") as! UITabBarController
        
        let currencyTab = tabBarVC.tabBar.items?[0]
        let historyTab = tabBarVC.tabBar.items?[1]
        let settingsTab = tabBarVC.tabBar.items?[2]
        
        /// Set individual tab bar elements appearance
        currencyTab?.title = "Currency"
        currencyTab?.image = UIImage(named: "currencyIcon")
        
        historyTab?.title = "History"
        historyTab?.image = UIImage(named: "historyIcon")
        
        settingsTab?.title = "Settings"
        settingsTab?.image = UIImage(named: "settingsIcon")
        

        tabBarVC.selectedIndex = 0
        
        
        return tabBarVC
    }
}

