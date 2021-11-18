//
//  OpenBeetoCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
protocol OpenBeeto {
    func openApp()
}

class OpenBeetoCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var openBeetoLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "OpenBeetoCell", bundle: nil)
    }
    static let identifier = "OpenBeetoCell"
    var delegate : OpenBeeto? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/15
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowRadius = 10
        openBeetoLabel.textColor = AppColor.appColor
    }
    func open(_ url: URL,
      options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
      completionHandler completion: ((Bool) -> Void)? = nil) {
        
    }

    
}
