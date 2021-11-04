//
//  NewsCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit

class NewsCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCell", bundle: nil)
    }
    static let identifier = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
