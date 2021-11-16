//
//  HomeCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 06/11/21.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var table_view: UITableView!
    
    static func nib() -> UINib {
        return UINib(nibName: "HomeCell", bundle: nil)
    }
    static let identifier = "HomeCell"
    override func awakeFromNib() {
        super.awakeFromNib()
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
        self.table_view.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.table_view.layer.shadowRadius = 2
        self.table_view.layer.shadowOpacity = 0.4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell.textLabel?.text = "Кэшбек"
            cell.detailTextLabel?.text = "2021-01-05 18:32"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
    }


}

