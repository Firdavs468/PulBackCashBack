//
//  LoginVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 28/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginVC: UIViewController {
    
    @IBOutlet weak var tiinMarketLabel: UILabel!
    @IBOutlet weak var nextButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var uncheckButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phoneNumberTF: CustomTF!
    @IBOutlet weak var fullTextLabel: UILabel!
    
    
    var isPressed1 : Bool = false
    var isPressed2 : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture()
        setupTextField()
        //        navBarBackground()
        multipleFontColorsSingleLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.height/2
    }
    
    @IBAction func uncheckButtonPressed(_ sender: Any) {
        if !isPressed1 {
            checkButton.setImage(UIImage(named: "check"), for: .normal)
            isPressed1 = true
        }else {
            checkButton.setImage(UIImage(named: "uncheck"), for: .normal)
            isPressed1 = false
        }
    }
    
    @IBAction func checkButtonPressed(_ sender: Any) {
        if !isPressed2 {
            uncheckButton.setImage(UIImage(named: "check"), for: .normal)
            isPressed2 = true
        }else {
            uncheckButton.setImage(UIImage(named: "uncheck"), for: .normal)
            isPressed2 = false
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        Cache.saveUserDefaults("22", forKey: "22")
        let phoneNumber = phoneNumberTF.text?.replacingOccurrences(of: "+998", with: "").replacingOccurrences(of: " ", with:"").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
        if let number = phoneNumber {
            Cache.saveUserDefaults(number, forKey: Keys.phone_number)
        }
        userLogin()
    }
    
    //Custom Text Field setup
    func setupTextField() {
        phoneNumberTF.title = "Номер мобильного"
        phoneNumberTF.placeholder = "+998"
        phoneNumberTF.keyboardType = .phonePad
        phoneNumberTF.delegate = self
    }
    
    //Use multiple font colors in a single label
    func multipleFontColorsSingleLabel() {
        
        //fullTextLabel
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.271, green: 0.741, blue: 0.659, alpha: 1).cgColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)] as [NSAttributedString.Key : Any]
        let yourAttributes2 = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let yourOtherAttributes2 = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.271, green: 0.741, blue: 0.659, alpha: 1).cgColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)] as [NSAttributedString.Key : Any]
        
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
        let tiinAtributs = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)]
        let tiinAtributs2 = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        
        let part1 = NSMutableAttributedString(string: "Я согласен с на получение сообшений об акциях, скидках и других рекламных уведомлений Tiin ", attributes: tiinAtributs)
        let part2 = NSMutableAttributedString(string: "Tiin Market", attributes: tiinAtributs2)
        
        let combination2 = NSMutableAttributedString()
        
        combination2.append(part1)
        combination2.append(part2)
        tiinMarketLabel.attributedText = combination2
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if ((textField.text?.isEmpty) != nil) {
            phoneNumberTF.rightButtonIcon = UIImage(systemName:"xmark.circle.fill")
        }else {
            phoneNumberTF.rightButtonIcon = UIImage(systemName: "")
        }
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

////MARK: - Navigation Controller Barbackground
//extension LoginVC {
//    func navBarBackground(){
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded();      self.navigationItem.hidesBackButton = true
//    }
//}
