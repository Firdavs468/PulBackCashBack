//
//  LoginVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 28/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps

class LoginVC: UIViewController {
//    case letsGoLbl
//    case mobileNumberLbl
//    case loginSmsLbl
//    case userAgreementLbl
//    case agreeLbl
    
    @IBOutlet weak var smsOrLoginLbl: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var letsGoLabel: UILabel!
    @IBOutlet weak var textFieldContainerView: UIView! {
        didSet {
            textFieldContainerView.layer.cornerRadius = textFieldContainerView.frame.height/9
        }
    }
    @IBOutlet weak var tiinMarketLabel: UILabel!
    @IBOutlet weak var uncheckButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var fullTextLabel: UILabel!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var phoneLabel: UILabel! {
        didSet {
            phoneLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    
    var isPressed1 : Bool = false
    var isPressed2 : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture()
        setupTextField()
        multipleFontColorsSingleLabel()
        newAppColor()
        setupLanguage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.height/2
    }
    
  
    @IBAction func clearTextButtonPressed(_ sender: Any) {
        phoneNumberTF.text = ""
    }
    
    
    @IBAction func uncheckButtonPressed(_ sender: Any) {
        if !isPressed1 {
            checkButton.setImage(AppIcon.check, for: .normal)
            isPressed1 = true
            if isPressed2 {
                nextButton.backgroundColor = AppColor.appColor
            }
        }else {
            nextButton.backgroundColor = .lightGray
            checkButton.setImage(AppIcon.rectangle, for: .normal)
            isPressed1 = false
        }
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        if !isPressed2 {
            uncheckButton.setImage(AppIcon.check, for: .normal)
            isPressed2 = true
            if isPressed1 {
                nextButton.backgroundColor = AppColor.appColor
                nextButton.isEnabled = true
            }
        }else {
            nextButton.backgroundColor = .lightGray
            nextButton.isEnabled = false
            uncheckButton.setImage(AppIcon.rectangle, for: .normal)
            isPressed2 = false
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        Cache.saveUserDefaults(phoneNumberTF.text, forKey: "phone")
        let phoneNumber = phoneNumberTF.text?.replacingOccurrences(of: "+998", with: "").replacingOccurrences(of: " ", with:"").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let number = phoneNumber {
            Cache.saveUserDefaults(number, forKey: Keys.phone_number)
        }
        if isPressed1 && isPressed2 && !phoneNumberTF.text!.isEmpty {
            userLogin()
        }else if phoneNumberTF.text!.isEmpty {
            Alert.showAlert(forState:.error, message: "Telefon raqam kiriting")
        }else {
            Alert.showAlert(forState: .error, message: "Foydalanuvchi shartnomasiga rozilik bering")
        }
    }
    
    //Custom Text Field setup
    func setupTextField() {
        phoneNumberTF.placeholder = "+998"
        phoneNumberTF.keyboardType = .phonePad
        phoneNumberTF.delegate = self
    }
    
    //New App Color
    func newAppColor() {
        uncheckButton.tintColor = AppColor.appColor
        checkButton.tintColor = AppColor.appColor
    }
    
    //Use multiple font colors in a single label
    func multipleFontColorsSingleLabel() {
        
        //fullTextLabel
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: AppColor.appColor.cgColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)] as [NSAttributedString.Key : Any]
        let yourAttributes2 = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let yourOtherAttributes2 = [NSAttributedString.Key.foregroundColor: AppColor.appColor.cgColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)] as [NSAttributedString.Key : Any]
        
        let partOne = NSMutableAttributedString(string: "Я согласен с ", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: " Пользовательским соглашением", attributes: yourOtherAttributes)
        let partThird = NSMutableAttributedString(string: " и даю ", attributes: yourAttributes2)
        let part4 = NSMutableAttributedString(string: "согласие на обработку персональных данных", attributes: yourOtherAttributes2)
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        combination.append(partThird)
        combination.append(part4)
        fullTextLabel.attributedText = combination
        
        //tiinMarketLabel
        let tiinAtributs = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        let tiinAtributs2 = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        
        let part1 = NSMutableAttributedString(string: "Я согласен с на получение сообшений об акциях, скидках и других рекламных уведомлений Tiin ", attributes: tiinAtributs)
        let part2 = NSMutableAttributedString(string: "Tiin Market", attributes: tiinAtributs2)
        
        let combination2 = NSMutableAttributedString()
        
        combination2.append(part1)
        combination2.append(part2)
        tiinMarketLabel.attributedText = combination2
    }
    
    //app language
    func setupLanguage() {
        letsGoLabel.text = AppLanguage.getTitle(type: .letsGoLbl)
        tiinMarketLabel.text = AppLanguage.getTitle(type: .userAgreementLbl)
        fullTextLabel.text = AppLanguage.getTitle(type: .agreeLbl)
        phoneNumberLabel.text = AppLanguage.getTitle(type: .mobileNumberLbl)
        smsOrLoginLbl.text = AppLanguage.getTitle(type: .loginSmsLbl)
    }
    
}


//MARK: - UITextField delegate
extension LoginVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+XXX (XX) XXX-XX-XX", phone: newString)
        return false
    }
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
}

//MARK: - Phone Number formatter
extension LoginVC {
    /// mask example: `+XXX (XX) XXX-XX-XX`
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                // move numbers iterator to the next index
                index = numbers.index(after: index)
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
}

//MARK: - User Login API
extension LoginVC {
    func userLogin() {
        let phoneNumber = phoneNumberTF.text?.replacingOccurrences(of: "+998", with: "").replacingOccurrences(of: " ", with:"").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let number = phoneNumber {
            let param = [
                "phone" : number
            ]
            Networking.fetchRequest(urlAPI: API.signInUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: Net.commonHeader) { data in
                if let data = data {
                    Loader.start()
                    print(JSON(data))
                    if data["code"].intValue == 0 {
                        Loader.stop()
                        Cache.saveUserDefaults(data["code"].intValue, forKey: Keys.code)
                        let vc = ConfirmationVC(nibName: "ConfirmationVC", bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }else if data["code"].intValue == 50000 {
                        Cache.saveUserDefaults(data["code"].intValue, forKey: Keys.code)
                        Loader.stop()
                        Alert.showAlert(forState: .warning, message: "Registratsiyadan o'ting")
                        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }else if data["code"].intValue == 50005 {
                        Cache.saveUserDefaults(data["code"].intValue, forKey: Keys.code)
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Tasdiqlash kodinin jo'natib bo'lmadi")
                    }else {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Nomalum xato")
                    }
                }
            }
        }
    }
}

