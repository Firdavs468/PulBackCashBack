//
//  TabBarController.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
import BarcodeScanner

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
        
        let viewController = BarcodeScannerViewController()
        viewController.tabBarItem.image = UIImage(named: "scaner")
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        
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
        
        viewControllers = [home,navbranches,viewController,navnews, navprofile]
    }
    
    @objc func selector() {
        print("hello world")
    }
    
}
//MARK: - BarCode delegate
extension TabBarController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
//        controller.reset()
        Cache.saveUserDefaults(code, forKey: Keys.bar_code)
        let vc = ProductsVC(nibName: "ProductsVC", bundle: nil)
        present(vc, animated: true, completion: nil)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error){
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

