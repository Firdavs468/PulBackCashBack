//
//  TabBarController.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate {
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let image = UIImage(named: "tabbar")
        //        let imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        setupTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func setupTabBar() {
        let home = HomeVC(nibName: "HomeVC", bundle: nil)
        home.tabBarItem.image = UIImage(named: "home")
        home.tabBarItem.title = "Главная"
        //        let navHome =  UINavigationController(rootViewController: home)
        
        let branches = BranchesVC(nibName: "BranchesVC", bundle: nil)
        branches.title = "Филиалы"
        branches.tabBarItem.image = UIImage(named: "branches")
        branches.tabBarItem.title = "Филиалы"
        let navbranches =  UINavigationController(rootViewController: branches)
        
        let qrcode = QRCodeVC(nibName: "QRCodeVC", bundle: nil)
        qrcode.tabBarItem.image = UIImage(named: "scaner")
        qrcode.tabBarItem.title = "QRCode"
        qrcode.tabBarItem.image?.withTintColor(UIColor(red: 0.286, green: 0.549, blue: 0.271, alpha: 0.3))
        //        let navqrcode =  UINavigationController(rootViewController: qrcode)
        
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
        
        viewControllers = [home,navbranches,qrcode,navnews, navprofile]
    }
    
    @objc func selector() {
        print("hello world")
    }
    
}
