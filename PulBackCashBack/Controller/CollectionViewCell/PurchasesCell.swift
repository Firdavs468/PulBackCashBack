//
//  PurchasesCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 09/11/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class PurchasesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var table_view: UITableView!
    static func nib() -> UINib {
        return UINib(nibName: "PurchasesCell", bundle: nil)
    }
    static let identifier = "PurchasesCell"
    
    var pays : [Pays] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        emptyLabel.isHidden = true
    }
    
}

//MARK: - TableView delegate methods
extension PurchasesCell : UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.table_view.tableFooterView = UIView()
        self.table_view.register(PurchasesTableCell.nib(), forCellReuseIdentifier: PurchasesTableCell.identifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !pays.isEmpty {
            return pays.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table_view.dequeueReusableCell(withIdentifier: PurchasesTableCell.identifier, for: indexPath) as! PurchasesTableCell
        if !pays.isEmpty {
            cell.updateCell(createdTime: pays[indexPath.row].created_date, totalPrice: "\(pays[indexPath.row].value)")
            emptyLabel.isHidden = true
            self.table_view.isHidden = false
            Loader.stop()
        }else {
            emptyLabel.isHidden = false
            emptyLabel.text = "Bo'sh"
            Loader.start()
            self.table_view.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Get Balance API
extension PurchasesCell {
    func getBalanceAPI() {
        if let token = Cache.getUserToken() {
            let headers :HTTPHeaders =
                [
                    "Authorization": "\(token)"
                ]
            Networking.fetchRequest(urlAPI: API.getBalanceUrl, method: .get, params: nil, encoding:JSONEncoding.default, headers: headers) { [self] data in
                if let data = data {
                    print(data)
                    let jsonData = JSON(data["data"])
                    let jsonPays =  jsonData["pays"]
                    if data["code"].intValue == 0 {
                        for i in 0..<jsonPays.count {
                            let pay = Pays(_id:jsonPays[i]["_id"].intValue , receipt: jsonPays[i]["receipt"].stringValue, value: jsonPays[i]["value"].intValue, total: jsonPays[i]["total"].intValue, created_date: jsonPays[i]["created_date"].stringValue)
                            self.pays.append(pay)
                            self.table_view.reloadData()
                        }
                    }
                }
            }
        }
    }
}
