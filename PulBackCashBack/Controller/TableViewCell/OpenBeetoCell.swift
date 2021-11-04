//
//  OpenBeetoCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit

class OpenBeetoCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    static func nib() -> UINib {
        return UINib(nibName: "OpenBeetoCell", bundle: nil)
    }
    static let identifier = "OpenBeetoCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/5
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowRadius = 2
    }
    
}
