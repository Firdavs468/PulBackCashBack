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
        tabBarController?.tabBar.items![3].badgeValue = "3"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func setupTabBar() {
        let home = HomeVC(nibName: "HomeVC", bundle: nil)
        home.tabBarItem.image = AppIcon.tabBarHome
        home.tabBarItem.title = AppLanguage.getTitle(type: .homeTitle)
        
        let branches = BranchesVC(nibName: "BranchesVC", bundle: nil)
        branches.title = AppLanguage.getTitle(type: .branchesNav)
        branches.tabBarItem.image = AppIcon.tabBarBraches
        branches.tabBarItem.title = AppLanguage.getTitle(type: .branchesNav)
        let navbranches =  UINavigationController(rootViewController: branches)
        
        let viewController = BarcodeScannerViewController()
//        viewController.tabBarItem.image = AppIcon.tabBarScaner
//        viewController.tabBarItem.image?.withTintColor(AppColor.appColor )
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        
        let news = NewsVC(nibName: "NewsVC", bundle: nil)
        news.title = AppLanguage.getTitle(type: .newsTitle)
        news.tabBarItem.image = AppIcon.tabBarNotification
        news.tabBarItem.title = AppLanguage.getTitle(type: .newsNav)
        let navnews =  UINavigationController(rootViewController: news)
        
        let profile = MyProfileVC(nibName: "MyProfileVC", bundle: nil)
        profile.title = AppLanguage.getTitle(type: .myProfileNav)
        profile.tabBarItem.image = UIImage(named: "user")
        profile.tabBarItem.title = AppLanguage.getTitle(type: .profileTitle)
        let navprofile =  UINavigationController(rootViewController: profile)
    
        viewControllers = [home, navbranches, viewController,  navnews, navprofile]
        setupMiddleButton()
    }
    
    @objc func selector() {
        print("hello world")
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

//        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "scaner"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }


    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
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

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        switch viewController {
            case is BarcodeScannerViewController :
                let vc = BarcodeScannerViewController(nibName: "BarcodeScannerViewController", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
                return false
            default:
                return true
        }
    }
}

