//
//  ProfileVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileVC: UIViewController {
    
    @IBOutlet weak var allStack: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var labelsStack: UIStackView!
    @IBOutlet weak var textFieldsStack: UIStackView!
    @IBOutlet var containerView: [UIView]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var familyStatusTextField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
        tapGesture()
        registerKeyboardNotifications()
        showDatePicker()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        Cache.saveUserDefaults(nameTextField.text, forKey: Keys.name)
        Cache.saveUserDefaults(nameTextField.text, forKey: Keys.surname)
        continueSignUp()
    }
    
    //TextField right button pressed
    
    //Name Button pressed
    @IBAction func nameButtonPressed(_ sender: Any) {
        nameTextField.text = ""
    }
    
    //surname button pressed
    @IBAction func surnameButtonPressed(_ sender: Any) {
        surnameTextField.text = ""
    }
    
    //birthday button pressed
    @IBAction func birthdayButtonPressed(_ sender: Any) {
        
    }
    
    //gender button pressed
    @IBAction func genderButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Jinsigizni tanlang", message: nil, preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Erkak", style: .default) { [self] _ in
            genderTextField.text = "Erkak"
            Cache.saveUserDefaults(1, forKey: Keys.gender)
        }
        let femele = UIAlertAction(title: "Ayol", style: .default) { [self] _ in
            genderTextField.text = "Ayol"
            Cache.saveUserDefaults(2, forKey: Keys.gender)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alert.addAction(male)
        alert.addAction(femele)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    //familiy status button pressed
    @IBAction func familyStatusButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Oilaviy xolatingizni tanlang", message: nil, preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Turmush qurgan", style: .default) { _ in
            self.familyStatusTextField.text = "Turmush qurgan"
            Cache.saveUserDefaults(2, forKey: Keys.family_status)
        }
        let female = UIAlertAction(title: "Turmush qurmagan", style: .default) { _ in
            self.familyStatusTextField.text = "Turmush qurmagan"
            Cache.saveUserDefaults(1, forKey: Keys.family_status)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //birthday. DatePicker
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.bordered, target: self, action: "donedatePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.bordered, target: self, action: "cancelDatePicker")
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        //        birthdayTF.accessoryView = toolbar
        // add datepicker to textField
        //        birthdayTF.textInputView = datePicker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        //        birthdayTF.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    //corner View /// corner Radius
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        for container in containerView {
            container.layer.cornerRadius = container.frame.height/10
        }
        
        //Setup constraint
        if isSmalScreen568 {
            labelsStack.spacing = 15
            textFieldsStack.spacing = 10
            allStack.spacing = 20
        }else {
            labelsStack.spacing = 20
            textFieldsStack.spacing = 15
            allStack.spacing = 25
        }
    }
    
    
}

//MARK: - Text Field Delegate
extension ProfileVC : UITextFieldDelegate {
    func tapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            print("namtf")
            surnameTextField.becomeFirstResponder()
        }else if textField == surnameTextField {
            birthdayTextField.becomeFirstResponder()
        }else if textField == birthdayTextField {
            genderTextField.becomeFirstResponder()
        }else if textField == genderTextField {
            familyStatusTextField.becomeFirstResponder()
        }else {
            nameTextField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Keyboard Handling
extension ProfileVC {
    
    func registerKeyboardNotifications() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let _ = keyboardInfo.cgRectValue.size
        
        UIView.animate(withDuration: 0.5) {
            if isSmalScreen568 {
                self.view.transform = CGAffineTransform(translationX: 0, y: -160)
            }else{
                self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5) {
            self.view.transform = .identity
        }
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

//MARK: - Continue Sign Up
extension ProfileVC {
    func continueSignUp() {
        let param : [String : Any] = [
            "phone" : Cache.getUserDefaultsString(forKey: Keys.phone_number)
        ]
        
        Networking.fetchRequest(urlAPI: API.continueSignUpUrl, method: .post, params: param, encoding: JSONEncoding.default, headers: Net.commonHeader) { data in
            if let data = data {
                Loader.start()
                print(data)
                if data["code"].intValue == 0 {
                    Loader.stop()
                    let vc = ConfirmationVC(nibName: "ConfirmationVC", bundle: nil)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else if data["code"].intValue == 50005 {
                    Loader.stop()
                    Alert.showAlert(forState: .error, message: "Foydalanuvchi topilmadi")
                }else {
                    Loader.stop()
                    Alert.showAlert(forState: .error, message: "Nomalum xato")
                }
            }
        }
    }
}
