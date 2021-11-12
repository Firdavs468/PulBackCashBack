//
//  MyProfileVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class MyProfileVC: UIViewController {
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            userImage.layer.cornerRadius = userImage.frame.height/2
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    let lblsArr = [
        "Настройки приложения",
        "О программе лояльности",
        "Поделиться приложением",
        "Жалобы и предложения"
    ]
    let imagesArr = [
        UIImage(named: "setting")!,
        UIImage(named: "information")!,
        UIImage(named: "wifi")!,
        UIImage(named: "message")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height/2
    }
    
    @IBAction func callCenterButtonPressed(_ sender: Any) {
        callNumber(phoneNumber: "+998945555892")
    }
    
}

//MARK: - TableView delegate methods
extension MyProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.table_view.tableFooterView = UIView()
        self.table_view.separatorStyle = .none
        self.table_view.register(ProfileCell.nib(), forCellReuseIdentifier: ProfileCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_view.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.updateCell(image:imagesArr[indexPath.row] , label: lblsArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let settings = Settings(nibName: "Settings", bundle: nil)
            navigationController?.pushViewController(settings, animated: true)
        }else if indexPath.row == 2 {
            shareApp()
        }else if indexPath.row == 3 {
            let vc = ReviewsVC(nibName: "ReviewsVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSmalScreen568 {
            return 60
        }else if isSmalScreen736 {
            return 70
        }else {
            return 80
        }
    }
    
}

//MARK: - Call center
extension MyProfileVC {
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

//MARK: - Share App
extension MyProfileVC {
    func shareApp() {
        if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
