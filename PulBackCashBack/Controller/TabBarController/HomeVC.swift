//
//  HomeVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var table_view: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1 {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: OpenBeetoCell.identifier, for: indexPath) as! OpenBeetoCell
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = self.table_view.dequeueReusableCell(withIdentifier: BonusesCell.identifier, for: indexPath) as! BonusesCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 100
        }else if indexPath.row == 0 {
            return 150
        }else {
            return 300
        }
    }
    
}
