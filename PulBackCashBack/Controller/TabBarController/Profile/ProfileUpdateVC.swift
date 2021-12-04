//
//  ProfileUpdateVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/12/21.
//

import UIKit

class ProfileUpdateVC: UIViewController {
    
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var requiredFieldLbl: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var familiyStatusTextField: UITextField!
    @IBOutlet weak var profilePhotoTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var containerView: [UIView]!
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    var datePicker = UIDatePicker()
    var selectedImage : UIImage? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appLanguage()
        cornerView()
        newAppColor()
        toolbar()
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = UIDatePicker.Mode.date
        birthdayTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(pickerDateChengedValue), for: .valueChanged)
        
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
    
    //gender button pressed
    @IBAction func genderButtonPressed(_ sender: Any) {
        self.genderAlert()
    }
    
    //familiy status button pressed
    @IBAction func familyStatusButtonPressed(_ sender: Any) {
        self.familiyStatusAlert()
    }
    
    @IBAction func selectPhotoButtonPressed(_ sender: Any) {
        photoLibraryAlert()
    }
    
    //new app color
    func newAppColor() {
        requiredFieldLbl.textColor = AppColor.appColor
        nextButton.backgroundColor = AppColor.appColor
    }
    
    //corner View /// corner Radius
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        for container in containerView {
            container.layer.cornerRadius = container.frame.height/10
        }
    }
    
    @objc func pickerDateChengedValue() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd" //"yyyy-MM-dd"
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    func toolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        toolbar.isTranslucent = true
        let selectedBtn = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(selectBtnPressed))
        var spaceBtn =  UIBarButtonItem()
        if #available(iOS 14.0, *) {
            spaceBtn =  UIBarButtonItem(systemItem: .flexibleSpace)
        } else {
            // Fallback on earlier versions
        }
        selectedBtn.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        birthdayTextField.inputAccessoryView = toolbar
        //passwordTF.inputAccessoryView = toolbar
        toolbar.items = [spaceBtn,selectedBtn]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc func tapped(){
        self.view.endEditing(true)
    }
    
    @objc func selectBtnPressed() {
        
        if nameTextField.isFirstResponder {
            surnameTextField.resignFirstResponder()
            birthdayTextField.becomeFirstResponder()
        }else {
            birthdayTextField.resignFirstResponder()
        }
        
    }
    
    
    
    //change app language
    func appLanguage() {
        
        profileLbl.text = AppLanguage.getTitle(type: .profileLbl)
        requiredFieldLbl.text = AppLanguage.getTitle(type: .profileRequiredLbl)
        nameTextField.placeholder = AppLanguage.getTitle(type: .namePlc)
        surnameTextField.placeholder = AppLanguage.getTitle(type: .surnamePlc)
        birthdayTextField.placeholder = AppLanguage.getTitle(type: .birthdayPlc)
        genderTextField.placeholder = AppLanguage.getTitle(type: .genderPlc)
        familiyStatusTextField.placeholder = AppLanguage.getTitle(type: .familyStatusPlc)
        profilePhotoTextField.placeholder = AppLanguage.getTitle(type: .profilePhotoPlc)
        
    }
    
    
}

//create alert
extension ProfileUpdateVC {
    
    //gender alert
    func genderAlert() {
        
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
    
    //familiy status alert
    func familiyStatusAlert() {
        let alert = UIAlertController(title: "Семеное положение", message: nil, preferredStyle: .actionSheet)
        let male = UIAlertAction(title: "Женатый", style: .default) { _ in
            self.familiyStatusTextField.text = "Женатый"
            Cache.saveUserDefaults(2, forKey: Keys.family_status)
        }
        let female = UIAlertAction(title: "Незамужняя", style: .default) { _ in
            self.familiyStatusTextField.text = "Незамужняя"
            Cache.saveUserDefaults(1, forKey: Keys.family_status)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        alert.addAction(male)
        alert.addAction(female)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

//open imagePicker controller
extension ProfileUpdateVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func photoLibraryAlert() {
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamer()
        }
        let photolibrary = UIAlertAction(title: "PhotoLibrary", style: .default) { _ in
            self.openGallery()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(photolibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallery() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary //.photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func openCamer() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .camera //.photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        selectedImage = tempImage
        selectPhotoButton.setImage(selectedImage, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
