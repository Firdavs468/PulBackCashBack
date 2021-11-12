//
//  NewsCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
import SDWebImage
class NewsCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCell", bundle: nil)
    }
    static let identifier = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/25
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.5
    }
    
    func updateCell(img:String, date:String) {
        self.img.sd_setImage(with: URL(string: API.base_url))
        self.dateLabel.text = date
    }
}
