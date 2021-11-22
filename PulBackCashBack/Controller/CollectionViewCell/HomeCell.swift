//
//  HomeCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 06/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var table_view: UITableView!
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeCell", bundle: nil)
    }
    static let identifier = "HomeCell"
    
    var pays : [Pays] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emptyLabel.text = "Нет бонусов"
        setupTableView()
    }
    
}

//MARK: - TableView delegate methods
extension HomeCell : UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.table_view.tableFooterView = UIView()
        self.table_view.layer.shadowColor = UIColor.systemGray.cgColor
        self.table_view.register(BonusesTableCell.nib(), forCellReuseIdentifier: BonusesTableCell.identifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !pays.isEmpty {
            return pays.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_view.dequeueReusableCell(withIdentifier: BonusesTableCell.identifier, for: indexPath) as! BonusesTableCell
        if !pays.isEmpty {
            cell.updateCell(value: "\(pays[indexPath.row].total)", createdTime: pays[indexPath.row].created_date)
            Loader.stop()
            self.table_view.isHidden = false
            emptyLabel.isHidden = true
            return cell
        }else {
            Loader.start()
            self.table_view.isHidden = true
            emptyLabel.isHidden = false
            emptyLabel.text = "Hech qanday bonuslar mavjuda emas"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Get Balance API
extension HomeCell {
    func getBalanceAPI() {
        if let token = Cache.getUserToken() {
            let headers :HTTPHeaders =
                [
                    "Authorization": "\(token)"
                ]
            Networking.fetchRequest(urlAPI: API.getBalanceUrl, method: .get, params: nil, encoding:JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    print(data)
                    Loader.start()
                    let jsonData = JSON(data["data"])
                    let jsonPays =  jsonData["pays"]
                    if data["code"].intValue == 0 {
                        Loader.stop()
                        for i in 0..<jsonPays.count {
                            let pay = Pays(_id:jsonPays[i]["_id"].intValue , receipt: jsonPays[i]["receipt"].stringValue, value: jsonPays[i]["value"].intValue, total: jsonPays[i]["total"].intValue, created_date: jsonPays[i]["created_date"].stringValue)
                            self.pays.append(pay)
                            self.table_view.reloadData()
                        }
                    }else if data["code"].intValue == 0 {
                        Loader.stop()
                        Alert.showAlert(forState: .error, message: "Платежи не найдены")
                    }
                }
            }
        }
    }
}
