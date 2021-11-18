//
//  ConfirmationVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//


//anor_p@ssw0rd
import UIKit
import Alamofire
import SwiftyJSON


//My Telegram code - 3434
class ConfirmationVC: UIViewController {
    
    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var counter = 59
    var userData : UserData! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
        setupTextField()
        tapGesture()
        phoneNumberLabel.text = "Номер мобильного  " +  Cache.getUserDefaultsString(forKey:"phone")
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    override func viewDidLayoutSubviews() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        nextButton.backgroundColor = AppColor.appColor
    }
    
    @IBAction func clearTextButtonPressed(_ sender: Any) {
        otpTF.text = ""
    }
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if UserDefaults.standard.integer(forKey: Keys.code) == 0 {
            userVerification()
        }else {
            userSignUp()
        }
    }
    
    
    //OTP timer
    @objc func updateCounter() {
        //example functionality
        if counter >= 0 {
            timerLabel.text = "00:\(counter) сек"
            counter -= 1
        }
    }
    
    
    
    func cornerView() {
        textFieldContainerView.layer.cornerRadius = textFieldContainerView.frame.height/10
        //Setup Constraint
        if isSmalScreen568 {
            otpLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            timerLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }else if isSmalScreen736 {
            otpLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            timerLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }else {
            otpLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            timerLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
    }
    
    //OTP customTF setup
    func setupTextField() {
        otpTF.placeholder = "Код подтверждения"
        otpTF.textContentType = .oneTimeCode
        otpTF.keyboardType = .numberPad
        otpTF.delegate = self
    }
    
}

//MARK: - Text Field Delegate
extension ConfirmationVC : UITextFieldDelegate {
    func tapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 4
    }
}

//User Verify
extension ConfirmationVC {
    func userVerification() {
        if let otp = otpTF.text {
            let param : [String : Any] = [
                "phone": Cache.getUserDefaultsString(forKey: Keys.phone_number),
                "code": otp
            ]
            print(param)
            print(Cache.isUserLogged())
            Networking.fetchRequest(urlAPI: API.verifyUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: Net.commonHeader) { data in
                if let data = data {
                    print(data)
                    Loader.start()
                    if data["code"].intValue == 0 {
                        Cache.saveUserToken(token: data["data"]["token"].stringValue)
                        Loader.stop()
                        Cache.saveUserDefaults(data["data"]["first_name"].stringValue, forKey: Keys.name)
                        Cache.saveUserDefaults(data["data"]["last_name"].stringValue, forKey: Keys.surname)
                        let vc = PinVC(nibName: "PinVC", bundle: nil)
                        let window = UIApplication.shared.keyWindow
                        let nav = UINavigationController(rootViewController: vc)
                        window?.rootViewController = nav
                        window?.makeKeyAndVisible()
                    }else if data["code"].intValue == 50003 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Nomalum tuzilma")
                    }else if data["code"].intValue == 50008 || data["code"].intValue == 50010  {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Tasdiqlash kodi xato kiritildi")
                    }else if data["code"].intValue == 50000 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Foydalanuvchi topilmadi")
                    }else if data["code"].intValue == 50009 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Token yaratib bo'lmadi")
                    }else {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Nomalum xato")
                    }
                }
            }
        }
    }
}
//MARK: - Anor group kodi -> anor_p@ssw0rd

//User Sign Up
extension ConfirmationVC {
    func userSignUp() {
        if let otp = otpTF.text {
            let param : [String : Any] = [
                "first_name": Cache.getUserDefaultsString(forKey: Keys.name),
                "last_name": Cache.getUserDefaultsString(forKey: Keys.surname),
                "birth_date": "2003-11-11T14:58:29.134673671+05:00",
                "gender": UserDefaults.standard.integer(forKey: Keys.gender),
                "family_status": UserDefaults.standard.integer(forKey: Keys.family_status),
                "phone": Cache.getUserDefaultsString(forKey: Keys.phone_number),
                "code": otp
            ]
            print(param)
            Networking.fetchRequest(urlAPI: API.signUpUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: Net.commonHeader) { data in
                if let data = data {
                    Loader.start()
                    print(data)
                    let jsonData = JSON(data)
                    if jsonData["code"].intValue == 0 {
                        Cache.saveUserToken(token: data["data"]["token"].stringValue)
                        Loader.stop()
                        let vc = PinVC(nibName: "PinVC", bundle: nil)
                        let window = UIApplication.shared.keyWindow
                        let nav = UINavigationController(rootViewController: vc)
                        window?.rootViewController = nav
                        window?.makeKeyAndVisible()
                    }else if jsonData["code"].intValue == 50006 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Foydalanuvchi uchun talab qilinadigan maydonlar toʻldirilmagan")
                    }else if jsonData["code"].intValue == 50008 || jsonData["code"].intValue == 50010  {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Tasdiqlash kodi xato kiritildi")
                    }else if jsonData["code"].intValue == 50007 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Server bilan bog'lanish vaqti tugadi")
                    }else if jsonData["code"].intValue == 50001 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Foydalanuvchi allaqachon ro'yxatdan o'tgan")
                    }else {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Nomalum xato")
                    }
                }
            }
        }
        
    }
}

