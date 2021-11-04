//
//  BonusesCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 03/11/21.
//

import UIKit

class BonusesCell: UITableViewCell {
    
    @IBOutlet weak var purchasesButton: UIButton!
    @IBOutlet weak var bonusesButton: UIButton!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var bonusesView: UIView!
    
    static func nib() -> UINib {
        return UINib(nibName: "BonusesCell", bundle: nil)
    }
    static let identifier = "BonusesCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    @IBAction func bonusesButtonPressed(_ sender: Any) {
        UIView.transition(with: bonusesView, duration: 0.4, options: .curveEaseIn) { [self] in
            self.bonusesView.transform = .identity
        }completion: { [self] _ in
            bonusesButton.setTitleColor(.black, for: .normal)
            purchasesButton.setTitleColor(.systemGray, for: .normal)
        }
    }
    
    @IBAction func purchasesButtonPressed(_ sender: Any) {
        UIView.transition(with: bonusesView, duration: 0.4, options: .curveEaseIn) { [self] in
            self.bonusesView.transform = CGAffineTransform(translationX: 205, y: 0)
        }completion: { [self] _ in
            bonusesButton.setTitleColor(.systemGray, for: .normal)
            purchasesButton.setTitleColor(.black, for: .normal)
        }
    }
    
}

//MARK: - TableView delegate methods
extension BonusesCell : UITableViewDelegate, UITableViewDataSource {
    
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
        cell.selectionStyle = .none
        cell.textLabel?.text = "Кэшбек"
        cell.detailTextLabel?.text = "2021-01-05 18:32"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table_view.deselectRow(at: indexPath, animated: true)
    }
    
    
}
