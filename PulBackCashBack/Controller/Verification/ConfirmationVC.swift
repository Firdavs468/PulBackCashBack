//
//  ConfirmationVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit

class ConfirmationVC: UIViewController {
    
    @IBOutlet weak var otpTF: CustomTF!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
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
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            timerLabel.text = "00:\(counter) сек"
            counter -= 1
        }
    }
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
    }
    
    func setupTextField() {
        otpTF.title = "Код из СМС"
        otpTF.placeholder = "Код подтверждения"
        otpTF.textContentType = .oneTimeCode
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
