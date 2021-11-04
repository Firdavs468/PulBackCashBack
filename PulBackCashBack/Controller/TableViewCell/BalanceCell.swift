//
//  BalanceCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class BalanceCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    static func nib() -> UINib {
        return UINib(nibName: "BalanceCell", bundle: nil)
    }
    static let identifier = "BalanceCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/6
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.5
    }
    
}
