//
//  MainVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 28/10/21.
//

import UIKit

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            if Cache.isUserLogged() {
                let pin = PinVC(nibName: "PinVC", bundle: nil)
                let window = UIApplication.shared.keyWindow
                let nav = UINavigationController(rootViewController: pin)
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            }else {
                let vc = LoginVC(nibName: "LoginVC", bundle: nil)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
