//
//  PinVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit
import LocalAuthentication

class PinVC: UIViewController {
    
    
    @IBOutlet var circleImage: [UIImageView]!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    @IBOutlet var numbersButton: [UIButton]!
    
    let circle  = UIImage(systemName: "circle")
    let circleFill = UIImage(systemName: "circle.fill")
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ПИН-код"
        cornerView()
        newAppColor()
        print(Cache.getUserDefaultsString(forKey: Keys.password), "password")
    }
    
    @IBAction func touchIdButtonPressed(_ sender: Any) {
        startAuthentication()
    }
    
    @IBAction func xButtonPressed(_ sender: Any) {
        if !UserDefaults.standard.bool(forKey: Keys.isLogged) {
            var password = Cache.getUserDefaultsString(forKey: Keys.password)
            if !password.isEmpty {
                password.removeLast()
                Cache.saveUserDefaults(password, forKey: Keys.password)
                let count =  Cache.getUserDefaultsString(forKey: Keys.password).count
                circleImage[count].image = circle
                print(Cache.getUserDefaultsString(forKey: Keys.password))
            }else {
                print("password empty")
            }
        }else {
            var checkingPassword = Cache.getUserDefaultsString(forKey: Keys.checkingPassword)
            if !checkingPassword.isEmpty {
                checkingPassword.removeLast()
                Cache.saveUserDefaults(checkingPassword, forKey: Keys.checkingPassword)
                let count = Cache.getUserDefaultsString(forKey: Keys.checkingPassword).count
                circleImage[count].image = circle
                print(Cache.getUserDefaultsString(forKey: Keys.checkingPassword))
            }
        }
    }
    
    @IBAction func numbersButtonPressed(_ sender: UIButton) {
        //button title
        if let text = sender.titleLabel?.text {
            //user logged
            if !UserDefaults.standard.bool(forKey: Keys.isLogged) {
                let count =  Cache.getUserDefaultsString(forKey: Keys.password).count
                // save user defaults
                if count < 4 {
                    circleImage[count].image = circleFill
                    let password = Cache.getUserDefaultsString(forKey: Keys.password) + text
                    Cache.saveUserDefaults(password, forKey: Keys.password)
                    print(Cache.getUserDefaultsString(forKey: Keys.password))
                    if count == 3 {
                        Alert.showAlert(forState: .success, message: "Parol muvaffiqiyatli yaratildi")
                        Cache.saveUserDefaults(true, forKey: Keys.isLogged)
                        let vc = TabBarController()
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: true, completion: nil)
                    }
                }else {
                    print("limit 4")
                }
            }else {
                let count = Cache.getUserDefaultsString(forKey: Keys.checkingPassword).count
                //save userdefaults
                if count < 4 {
                    circleImage[count].image = circleFill
                    let checkingPassword = Cache.getUserDefaultsString(forKey: Keys.checkingPassword) + text
                    Cache.saveUserDefaults(checkingPassword, forKey: Keys.checkingPassword)
                    print(Cache.getUserDefaultsString(forKey: Keys.checkingPassword))
                    if count == 3 {
                        let checking = Cache.getUserDefaultsString(forKey: Keys.checkingPassword)
                        let password = Cache.getUserDefaultsString(forKey: Keys.password)
                        if checking == password {
                            Alert.showAlert(forState: .success, message: "parol to'gri")
                            Cache.saveUserDefaults(nil, forKey: Keys.checkingPassword)
                            let vc = TabBarController()
                            vc.modalPresentationStyle = .fullScreen
                            present(vc, animated: true, completion: nil)
                        }else {
                            Alert.showAlert(forState: .error, message: "Parol noto'g'ri kiritildi")
                            Cache.saveUserDefaults(nil, forKey: Keys.checkingPassword)
                            for i in circleImage {
                                i.image = circle
                            }
                        }
                    }
                }
            }
        }
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
        for number in numbersButton {
            number.tintColor = AppColor.appColor
            number.layer.cornerRadius = number.frame.height/10
        }
    }
    
    //New App Color
    func newAppColor() {
        for number in numbersButton {
            number.tintColor = AppColor.appColor
        }
        touchIDButton.tintColor = AppColor.appColor
        xButton.tintColor = AppColor.appColor
    }
    
}




