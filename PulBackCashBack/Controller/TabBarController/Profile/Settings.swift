//
//  Settings.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
import SheetViewController

class Settings: UIViewController {
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var supportButton: UIButton!
    
    let cellNamesArrRus = [
        "Изменить ПИН-код",
        "Изменить ПИН-код",
        "Удалить ПИН-код",
        "Выберите язык",
        "Редактировать профиль"
    ]
    
    let cellNamesArrUzb = [
        "PIN-kodni o'zgartirish",
        "PIN-kodni o'zgartirish",
        "PIN-kodni olib tashlash",
        "Tilni tanlang",
        "Profilni tahrirlash"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AppLanguage.getTitle(type: .settingsNav)
        setupTableView()
        appLanguage()
    }
    @IBAction func callCenterButtonPressed(_ sender: Any) {
        callNumber(phoneNumber: "+998945555892")
    }
    
    func appLanguage() {
        supportButton.setTitle(AppLanguage.getTitle(type: .SupportLbl), for: .normal)
    }
}

//MARK: - TableView delegate methods
extension Settings : UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        //        self.table_view.separatorStyle = .none
        self.table_view.tableFooterView = UIView()
        self.table_view.register(SettingsCell.nib(), forCellReuseIdentifier: SettingsCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNamesArrUzb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
            return cell
        }else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            let language = Cache.getUserDefaultsString(forKey: Keys.language)
            
            if language == "uz" {
                cell.textLabel?.text = cellNamesArrUzb[indexPath.row]
            }else {
                cell.textLabel?.text = cellNamesArrRus[indexPath.row]
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 2 {
            deletePinCodeAlert()
        }else if indexPath.row == 1 {
            changePasswordAlert()
        }else if indexPath.row == 3 {
            self.chooseLanguageAlert()
        }else {
            let vc = ProfileUpdateVC(nibName: "ProfileUpdateVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }else {
            if isSmalScreen568 {
                return 60
            }else if isSmalScreen736 {
                return 70
            }else {
                return 80
            }
        }
    }
    
}

//MARK: - Call center
extension Settings {
    //call center number
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }else {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Phone number is not available for this business"
                alert.addButton(withTitle: "Ok")
                alert.show()
            }
        }
    }
    
    //change app languages
    func chooseLanguageAlert() {
        let languageAlert = UIAlertController(title: "Выберите язык ", message: nil, preferredStyle: .actionSheet)
        let russian = UIAlertAction(title: "Русский ", style: .default) { _ in
            Cache.saveUserDefaults("0", forKey: Keys.languages)
            Cache.saveUserDefaults("rus", forKey: Keys.language)
            self.sharedWindow()
        }
        
        let uzbek = UIAlertAction(title: "O'zbekcha", style: .default) { _ in
            Cache.saveUserDefaults("uz", forKey: Keys.language)
            Cache.saveUserDefaults("1", forKey: Keys.languages)
            self.sharedWindow()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let key = Int(Cache.getUserDefaultsString(forKey: Keys.languages))
        
        languageAlert.addAction(russian)
        languageAlert.addAction(uzbek)
        languageAlert.addAction(cancel)
        
        languageAlert.actions[key ?? 0].setValue(UIColor.systemGray, forKey: "titleTextColor")
        present(languageAlert, animated: true, completion: nil)
        
    }
    
    // delete pin code alert
    func deletePinCodeAlert() {
        let alert = UIAlertController(title: "Удалить ПИН-код", message: "Вы хотите удалить пин-код?", preferredStyle: .alert)
        let no = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        
        let yes = UIAlertAction(title: "Да", style: .default) { _ in
            Cache.saveUserDefaults(nil, forKey: Keys.password)
            Cache.saveUserDefaults(false, forKey: Keys.isLogged)
            DoneAlert.showAlert(title: "Пин-код был удален")
        }
        
        alert.addAction(no)
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
    }
    
    //change password alert
    func changePasswordAlert() {
        let alert = UIAlertController(title: "Изменить ПИН -код", message: "Вы хотите Изменить пин-код?", preferredStyle: .alert)
        let no = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Да", style: .default) { _ in
            
            Cache.saveUserDefaults(false, forKey: Keys.isLogged)
            Cache.saveUserDefaults(nil, forKey: Keys.password)
            
            let vc = PinVC(nibName: "PinVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        alert.addAction(no)
        alert.addAction(yes)
        
        present(alert, animated: true, completion: nil)
    }
    
    func sharedWindow() {
        let window = UIApplication.shared.keyWindow
        let tabbar = TabBarController()
        Loader.start()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            Loader.start()
            window?.rootViewController = tabbar
            window?.makeKeyAndVisible()
        }
        Loader.stop()
    }
}
