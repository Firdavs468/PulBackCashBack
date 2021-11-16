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
        self.tabBar.backgroundColor = .systemGray6
        //        let bgView: UIImageView = UIImageView(image: UIImage(named: "tabbar"))
        //        bgView.frame = CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.width, height: 100) //you might need to modify this frame to your tabbar frame
        //        self.view.addSubview(bgView)
        //        tabBar.backgroundImage = UIImage(named: "tabbar")
        setupTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        let newTabBarHeight = defaultTabBarHeight + 76.0
        //        var newFrame = tabBar.frame
        //        newFrame.size.height = newTabBarHeight
        //        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        //        tabBar.frame = newFrame
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
        qrcode.tabBarItem.image = UIImage(named: "scanner")
        qrcode.tabBarItem.title = "QRCode"
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
