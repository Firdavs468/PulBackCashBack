//
//  AppDelegate.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 28/10/21.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        
        UIApplication.shared.statusBarStyle = .lightContent
        GMSServices.provideAPIKey("AIzaSyDOyOZf1XkqaKBKS5ZOS4PuSI95jha56N0")
        UITabBar.appearance().tintColor = UIColor(red: 0.278, green: 0.749, blue: 0.639, alpha: 1)
        UITabBar.appearance().backgroundImage = UIImage(named: "tabbar")
        UINavigationBar.appearance().setBackgroundImage(UIImage(named:"navbar"),
                                                        for: .default)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        if Cache.isUserLogged() {
            let tabbar = TabBarController()
            let nav = UINavigationController(rootViewController: tabbar)
            window?.rootViewController = nav
        }else {
            let main = MainVC(nibName: "MainVC", bundle: nil)
            window?.rootViewController = main
        }
        window?.makeKeyAndVisible()
        return true
    }
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}
