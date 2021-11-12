//
//  ProfileVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var allStack: UIStackView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameTF: CustomTF!
    @IBOutlet weak var surnamTF: CustomTF!
    @IBOutlet weak var birthdayTF: CustomTF!
    @IBOutlet weak var genderTF: CustomTF!
    @IBOutlet weak var maritalStatusTF: CustomTF!
    @IBOutlet weak var labelsStack: UIStackView!
    @IBOutlet weak var textFieldsStack: UIStackView!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
        setupTextField()
        tapGesture()
        registerKeyboardNotifications()
        showDatePicker()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = PinVC(nibName: "PinVC", bundle: nil)
        let window = UIApplication.shared.keyWindow
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
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
        birthdayTF.accessoryView = toolbar
        // add datepicker to textField
        birthdayTF.textInputView = datePicker
        
    }
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        birthdayTF.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        
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
    
    func setupTextField() {
        nameTF.tag = 0
        surnamTF.tag = 1
        birthdayTF.tag = 2
        genderTF.tag = 3
        maritalStatusTF.tag = 4
        nameTF.delegate = self
        surnamTF.delegate = self
        birthdayTF.delegate = self
        genderTF.delegate = self
        maritalStatusTF.delegate = self
        
        nameTF.placeholder = "Имя * "
        surnamTF.placeholder = "Фамилия *"
        birthdayTF.placeholder = "Дата рождения * "
        genderTF.placeholder = "Пол"
        genderTF.rightButtonIcon = UIImage(systemName: "chevron.right")
        genderTF.rightButtonTapped()
        maritalStatusTF.placeholder = "Семеное положение"
        maritalStatusTF.rightButtonIcon = UIImage(systemName: "chevron.right")
    }
    
}

//MARK: - Text Field Delegate
extension ProfileVC : UITextFieldDelegate {
    func tapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if ((textField.text?.isEmpty) != nil) {
            nameTF.rightButtonIcon = UIImage(systemName:"xmark.circle.fill")
            surnamTF.rightButtonIcon = UIImage(systemName:"xmark.circle.fill")
        }else {
            nameTF.rightButtonIcon = UIImage(systemName: "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            print("namtf")
            surnamTF.becomeFirstResponder()
        }else if textField == surnamTF {
            birthdayTF.becomeFirstResponder()
        }else if textField == birthdayTF {
            genderTF.becomeFirstResponder()
        }else if textField == genderTF {
            maritalStatusTF.becomeFirstResponder()
        }else {
            nameTF.resignFirstResponder()
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
