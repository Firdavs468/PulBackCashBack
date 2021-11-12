//
//  TabBarController.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        let home = HomeVC(nibName: "HomeVC", bundle: nil)
        home.title = "Добрый день,Муроджон Турсунов!"
        home.tabBarItem.image = UIImage(named: "home")
        home.tabBarItem.title = "Главная"
        let navHome =  UINavigationController(rootViewController: home)
        
        let branches = BranchesVC(nibName: "BranchesVC", bundle: nil)
        branches.title = "Филиалы"
        branches.tabBarItem.image = UIImage(named: "branches")
        branches.tabBarItem.title = "Филиалы"
        let navbranches =  UINavigationController(rootViewController: branches)
        
        let qrcode = QRCodeVC(nibName: "QRCodeVC", bundle: nil)
        qrcode.tabBarItem.image = UIImage(named: "scanner")
        qrcode.tabBarItem.title = "QRCode"
        let navqrcode =  UINavigationController(rootViewController: qrcode)
        
        let news = NewsVC(nibName: "NewsVC", bundle: nil)
        news.title = "Новости"
        news.tabBarItem.image = UIImage(named: "notification")
        news.tabBarItem.title = "Новости"
        let navnews =  UINavigationController(rootViewController: news)
        
        let profile = MyProfileVC(nibName: "MyProfileVC", bundle: nil)
        profile.title = "Профиль"
        profile.tabBarItem.image = UIImage(named: "user")
        profile.tabBarItem.title = "Профиль"
        let navprofile =  UINavigationController(rootViewController: profile)
        
        viewControllers = [navHome,navbranches,navqrcode,navnews, navprofile]
    }
    
    @objc func selector() {
        print("hello world")
    }
    
}
