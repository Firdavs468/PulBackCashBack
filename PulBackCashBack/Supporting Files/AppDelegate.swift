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
        UITabBar.appearance().tintColor = AppColor.appColor
        //        UITabBar.appearance().backgroundImage = UIImage(named: "tabbar")
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
            let pin = PinVC(nibName: "PinVC", bundle: nil)
            window?.rootViewController = pin
        }else {
            let main = MainVC(nibName: "MainVC", bundle: nil)
            window?.rootViewController = main
        }
//        Cache.saveUserDefaults(nil, forKey: Keys.password)
        window?.makeKeyAndVisible()
        return true
    }
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}
