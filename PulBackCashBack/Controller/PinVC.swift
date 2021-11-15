//
//  PinVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit
import LocalAuthentication

class PinVC: UIViewController {
    
    
    @IBOutlet weak var nextButtonTop: NSLayoutConstraint!
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet var numbersButton: [UIButton]!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ПИН-код"
        navigationController?.navigationBar.barTintColor = UIColor.green
        cornerView()
        //        startAuthentication()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @IBAction func touchIdButtonPressed(_ sender: Any) {
        startAuthentication()
    }
    
    func   startAuthentication() {
        let context = LAContext()
        var error : NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("success")
                    }else {
                        //error
                        let alert = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }else {
            //no biometry
            let alert = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for boimetric authentication", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //cornerView
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        for number in numbersButton {
            number.layer.cornerRadius = number.frame.height/10
            //            number.layer.shadowColor = UIColor.systemGray.cgColor
            //            number.layer.shadowOffset = CGSize(width: 0, height: 0)
            //            number.layer.shadowRadius = 5
            //            number.layer.shadowOpacity = 0.2
        }
        
        //setup constraint
        if isSmalScreen568 {
            passwordStack.spacing = 25
            nextButtonTop.constant = 30
        }else {
            passwordStack.spacing = 35
            nextButtonTop.constant = 50
        }
    }
    
}




