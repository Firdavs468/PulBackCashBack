//
//  Settings.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit

class Settings: UIViewController {
    
    @IBOutlet weak var table_view: UITableView!
    
    let cellNamesArr = [
        "Изменить ПИН-код",
        "Изменить ПИН-код",
        "Удалить ПИН-код",
        "Выберите язык"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        setupTableView()
    }
    @IBAction func callCenterButtonPressed(_ sender: Any) {
        callNumber(phoneNumber: "+998945555892")
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
        cellNamesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
            return cell
        }else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = cellNamesArr[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            Cache.saveUserDefaults(nil, forKey: Keys.password)
            Cache.saveUserDefaults(false, forKey: Keys.isLogged)
            DoneAlert.showAlert(title: "Пин-код был удален")
        }else if indexPath.row == 1 {
            Cache.saveUserDefaults(false, forKey: Keys.isLogged)
            Cache.saveUserDefaults(nil, forKey: Keys.password)
            let vc = PinVC(nibName: "PinVC", bundle: nil)
            self.present(vc, animated: true, completion: nil)
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
}
