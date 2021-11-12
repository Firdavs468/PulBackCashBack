//
//  ConfirmationVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConfirmationVC: UIViewController {
    
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpTF: CustomTF!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nextButtonWidth: NSLayoutConstraint!
    
    var counter = 59
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
        setupTextField()
        tapGesture()
        phoneNumberLabel.text = "Номер мобильного" +  Cache.getUserDefaultsString(forKey: Keys.phone_number)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        //        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true, completion: nil)
        userVerification()
    }
    
    
    //OTP timer
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            timerLabel.text = "00:\(counter) сек"
            counter -= 1
        }
    }
    
    
    
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        
        //Setup Constraint
        if isSmalScreen568 {
            otpLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            timerLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }else if isSmalScreen736 {
            otpLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            timerLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }else {
            otpLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            timerLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
    }
    
    //OTP customTF setup
    func setupTextField() {
        otpTF.title = "Код из СМС"
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if ((textField.text?.isEmpty) != nil) {
            otpTF.rightButtonIcon = UIImage(systemName:"xmark.circle.fill")
        }else {
            otpTF.rightButtonIcon = UIImage(systemName: "")
        }
    }
}

extension ConfirmationVC {
    func userVerification() {
        if let otp = otpTF.text {
            
            let param : [String : Any] = [
                "phone": Cache.getUserDefaultsString(forKey: Keys.phone_number),
                "code": otp
            ]
            let headers : HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            AF.request(API.verifyUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if let data = response.data {
                    print(JSON(data))
                    let jsonData = JSON(data)
                    if jsonData["code"].intValue == 0 {
                        //                        let vc = ConfirmationVC(nibName: "ConfirmationVC", bundle: nil)
                        //                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

