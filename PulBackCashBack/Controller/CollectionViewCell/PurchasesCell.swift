//
//  PurchasesCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 09/11/21.
//

import UIKit


import UIKit

class PurchasesCell: UICollectionViewCell {

    
    @IBOutlet weak var table_view: UITableView!
    static func nib() -> UINib {
        return UINib(nibName: "PurchasesCell", bundle: nil)
    }
    static let identifier = "PurchasesCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

}

//MARK: - TableView delegate methods
extension PurchasesCell : UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.table_view.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "Покупка"
            cell.detailTextLabel?.text = "2021-01-05 18:32"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
    }


}

