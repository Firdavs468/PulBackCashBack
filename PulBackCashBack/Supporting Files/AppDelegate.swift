//
//  AppDelegate.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 28/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        UITabBar.appearance().tintColor = UIColor(red: 0.278, green: 0.749, blue: 0.639, alpha: 1)
        
//        let vc = MainVC(nibName: "MainVC", bundle: nil)
        let login = LoginVC(nibName: "LoginVC", bundle: nil)
        let nav = UINavigationController(rootViewController: login)
        nav.navigationBar.backgroundColor = .green
        let tabbar = TabBarController()
        window?.rootViewController = tabbar
        window?.makeKeyAndVisible()
        return true
    }
}

