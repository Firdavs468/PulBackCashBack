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
        balancLabel.textColor = UIColor(red: 0.09, green: 0.549, blue: 0.514, alpha: 1)
        containerView.layer.cornerRadius = containerView.frame.height/15
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 100
        containerView.layer.shadowOpacity = 0.3
    }
    
}
