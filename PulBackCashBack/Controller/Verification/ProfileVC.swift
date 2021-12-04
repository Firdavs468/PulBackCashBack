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
    
    @IBOutlet weak var cashBackCardLbl: UILabel!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var containerView: [UIView]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var familyStatusTextField: UITextField!
    @IBOutlet weak var continueLabel: UILabel!
    
    var picker = UIDatePicker()
    var comp = NSDateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
        tapGesture()
        registerKeyboardNotifications()
        newAppColor()
        setupLanguage()
    }
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        Cache.saveUserDefaults(nameTextField.text, forKey: Keys.name)
        Cache.saveUserDefaults(surnameTextField.text, forKey: Keys.surname)
        Cache.saveUserDefaults(birthdayTextField.text!+"T14:58:29.134673671+05:00",forKey: Keys.bithday)
        if nameTextField.text!.isEmpty || birthdayTextField.text!.isEmpty {
            Alert.showAlert(forState: .error, message: "Ma'lumotlarni to'ldiring")
        }else {
            continueSignUp()
        }
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
        showDatePicker()
    }
    
    //gender button pressed
    @IBAction func genderButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Пол", message: nil, preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Мужчина", style: .default) { [self] _ in
            genderTextField.text = "Мужчина"
            Cache.saveUserDefaults(1, forKey: Keys.gender)
        }
        let femele = UIAlertAction(title: "Женщина", style: .default) { [self] _ in
            genderTextField.text = "Женщина"
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
        let alert = UIAlertController(title: "Семеное положение", message: nil, preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Женатый", style: .default) { _ in
            self.familyStatusTextField.text = "Женатый"
            Cache.saveUserDefaults(2, forKey: Keys.family_status)
        }
        let female = UIAlertAction(title: "Незамужняя", style: .default) { _ in
            self.familyStatusTextField.text = "Незамужняя"
            Cache.saveUserDefaults(1, forKey: Keys.family_status)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    //new app color
    func newAppColor() {
        requiredLabel.textColor = AppColor.appColor
        nextButton.backgroundColor = AppColor.appColor
    }
    
    //corner View /// corner Radius
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        for container in containerView {
            container.layer.cornerRadius = container.frame.height/10
        }
    }
    
    
    // datePicker setup
    func showDatePicker() {
        //T14:58:29.134673671+05:00
        picker = UIDatePicker()
        birthdayTextField.inputView = picker
        picker.addTarget(self, action: #selector(ProfileVC.handleDatePicker), for: UIControl.Event.valueChanged)
        picker.datePickerMode = .date
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthdayTextField.text = dateFormatter.string(from: picker.date)
        birthdayTextField.resignFirstResponder()
    }
    
    //app language
    func setupLanguage() {
        profileLbl.text = AppLanguage.getTitle(type: .profileLbl)
        cashBackCardLbl.text = AppLanguage.getTitle(type: .cashBackCardLbl)
        requiredLabel.text = AppLanguage.getTitle(type: .requiredFieldsLbl)
        nameTextField.placeholder = AppLanguage.getTitle(type: .namePlc)
        surnameTextField.placeholder = AppLanguage.getTitle(type: .surnamePlc)
        birthdayTextField.placeholder = AppLanguage.getTitle(type: .birthdayPlc)
        genderTextField.text = AppLanguage.getTitle(type: .genderPlc)
        familyStatusTextField.placeholder = AppLanguage.getTitle(type: .familyStatusPlc)
        continueLabel.text = AppLanguage.getTitle(type: .proccedLbl)
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
            }else if isSmalScreen736 {
                self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            }else {
                self.view.transform = CGAffineTransform(translationX: 0, y: -70)
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
