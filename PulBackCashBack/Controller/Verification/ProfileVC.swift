//
//  ProfileVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 01/11/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nameTF: CustomTF!
    @IBOutlet weak var surnamTF: CustomTF!
    @IBOutlet weak var birthdayTF: CustomTF!
    @IBOutlet weak var genderTF: CustomTF!
    @IBOutlet weak var maritalStatusTF: CustomTF!
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerView()
        setupTextField()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let vc = PinVC(nibName: "PinVC", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cornerView() {
        nextButton.layer.cornerRadius = nextButton.frame.height/2
    }
    
    func setupTextField() {
        nameTF.placeholder = "Имя * "
        surnamTF.placeholder = "Фамилия *"
        birthdayTF.placeholder = "Дата рождения * "
        genderTF.placeholder = "Пол"
        genderTF.rightButtonIcon = UIImage(systemName: "chevron.right")
        maritalStatusTF.placeholder = "Семеное положение"
        maritalStatusTF.rightButtonIcon = UIImage(systemName: "chevron.right")
    }
}
