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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCell", bundle: nil)
    }
    static let identifier = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/25
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.3
    }
    
    func updateCell(img:String, date:String,content:String, title:String) {
        let urlString = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? img
        self.img.sd_setImage(with: URL(string:"http://89.223.71.112:9494/image?path="+urlString))
        self.dateLabel.text = date
        self.titleLabel.text = title
        self.contentLabel.text = content
    }
}
