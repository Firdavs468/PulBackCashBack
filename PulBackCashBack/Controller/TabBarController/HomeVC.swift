//
//  HomeVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class HomeVC: UIViewController, OpenBeeto {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var table_view: UITableView!
    
    
    var pays : [Pays] = []
    var balanceStr = 0
    let userName = BalanceCell.userName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getBalanceAPI()
        setupUserLabel()
        
        self.table_view.reloadData()
    }
    
    //userLabel setup
    func setupUserLabel() {
        userLabel.lineBreakMode = .byCharWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        userLabel.numberOfLines = 0
        
        userLabel.attributedText = NSMutableAttributedString(string: AppLanguage.getTitle(type: .goodDayLbl), attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
}

//MARK: - TableView delegate methods
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.table_view.separatorStyle = .none
        self.table_view.tableFooterView = UIView()
        
        self.table_view.register(OpenBeetoCell.nib(), forCellReuseIdentifier: OpenBeetoCell.identifier)
        self.table_view.register(BalanceCell.nib(), forCellReuseIdentifier: BalanceCell.identifier)
        self.table_view.register(BonusesCell.nib(), forCellReuseIdentifier: BonusesCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: BalanceCell.identifier, for: indexPath) as! BalanceCell
            cell.updateCell(balance: "\(balanceStr)")
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1 {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: OpenBeetoCell.identifier, for: indexPath) as! OpenBeetoCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: BonusesCell.identifier, for: indexPath) as! BonusesCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //card flip animation
        if indexPath.row == 1 {
            if isSmalScreen568 {
                return 110
            }else {
                return 130
            }
        }
        //go to Beeto
        else if indexPath.row == 0 {
            if isSmalScreen568 {
                return 180
            }else if isSmalScreen736 {
                return 200
            }else {
                return 240
            }
        }
        //bonuses collection cell
        else {
            return 380
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            openApp()
        }
    }
}

//MARK: go to Beeto
extension UIViewController {
    func openApp() {
        let appURLScheme = AppURL.openBeeto
        guard let appURL = URL(string: appURLScheme) else {
            return
        }
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            }else {
                UIApplication.shared.openURL(appURL)
            }
        }else {
            // Here you can handle the case when your other application cannot be opened for any reason.
        }
    }
}

//MARK: - Navigation Controller Barbackground
extension HomeVC {
    func navBarBackground(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded();
        self.navigationItem.hidesBackButton = true
    }
}

//MARK: - Get Balance API
extension HomeVC {
    func getBalanceAPI() {
        if let token = Cache.getUserToken() {
            let headers :HTTPHeaders =
                [
                    "Authorization": "\(token)"
                ]
            Networking.fetchRequest(urlAPI: API.getBalanceUrl, method: .get, params: nil, encoding:JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    Loader.start()
                    let jsonData = JSON(data["data"])
                    if data["code"].intValue == 0 {
                        Loader.stop()
                        balanceStr = jsonData["balance"].intValue
                        self.table_view.reloadData()
                    }
                }
            }
        }
    }
}
