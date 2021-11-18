//
//  BalanceCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class BalanceCell: UITableViewCell {
    
    @IBOutlet weak var balancLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static func nib() -> UINib {
        return UINib(nibName: "BalanceCell", bundle: nil)
    }
    static let identifier = "BalanceCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        balancLabel.textColor = AppColor.appColor
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 30
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.systemGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.4
    }
    
    func updateCell(balance:String) {
        self.balancLabel.text = balance
    }
    
}
