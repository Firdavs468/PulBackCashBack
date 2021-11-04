//
//  ProfileCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileCell", bundle: nil)
    }
    static let identifier = "ProfileCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/10
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.5
    }
    
    func updateCell(image:UIImage, label:String) {
        self.img.image = image
        self.lbl.text = label
    }
    
}
