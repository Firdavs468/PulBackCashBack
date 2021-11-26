//
//  NewsCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 23/11/21.
//

import UIKit
import SDWebImage
class NewsCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCell", bundle: nil)
    }
    static let identifier = "NewsCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = containerView.frame.height/20
//        setupContainerView()
    }
    
    func updateCell(img:String, created_at:String, content:String) {
        self.img.sd_setImage(with: URL(string: API.EndPoints.getImage+img), placeholderImage: AppIcon.noItem)
        self.createdAtLabel.text = created_at
        self.contentLabel.text = content
    }
    
    func setupContainerView() {
        self.containerView.layer.cornerRadius = containerView.frame.height/20
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.containerView.layer.shadowRadius = 5
        self.containerView.layer.shadowOpacity = 0.5
    }
    
}
