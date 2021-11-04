//
//  LoginVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 28/10/21.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var uncheckButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phoneNumberTF: CustomTF!
    
    var isPressed1 : Bool = false
    var isPressed2 : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture()
        cornerView()
        setupTextField()
        //        navBarBackground()
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
            uncheckButton.setImage(UIImage(named: "uncheck"), for: .normal)
            isPressed2 = true
        }else {
            uncheckButton.setImage(UIImage(named: "check"), for: .normal)
            isPressed2 = false
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if ((phoneNumberTF.text?.isEmpty) != nil) {
            
        }
        Cache.saveUserDefaults(phoneNumberTF.text, forKey: Keys.phone_number)
        let vc = ConfirmationVC(nibName: "ConfirmationVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
    }
    
    func setupTextField() {
        phoneNumberTF.title = "Номер мобильного"
        phoneNumberTF.placeholder = "+998"
        phoneNumberTF.keyboardType = .numberPad
        phoneNumberTF.delegate = self
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

////MARK: - Navigation Controller Barbackground
//extension LoginVC {
//    func navBarBackground(){
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded();      self.navigationItem.hidesBackButton = true
//    }
//}
