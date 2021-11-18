//
//  ReviewsCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 16/11/21.
//

import UIKit

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "ReviewsCell", bundle: nil)
    }
    static let identifier = "ReviewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/15
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.4
    }
    
    func updateCell(lbl:String, buttonImage:UIImage) {
        self.lbl.text = lbl
        self.btn.setImage(buttonImage, for: .normal)
    }
    
}
