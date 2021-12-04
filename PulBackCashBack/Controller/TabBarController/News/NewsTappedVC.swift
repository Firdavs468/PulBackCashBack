//
//  NewsTappedVC.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 09/11/21.
//

import UIKit

class NewsTappedVC: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var getBanner : GetBannerNews!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGetBanner()
        title = AppLanguage.getTitle(type: .newsNav)
    }
    
    func setupGetBanner() {
        img.sd_setImage(with: URL(string: API.EndPoints.getImage + getBanner.image), placeholderImage: AppIcon.noItem)
        titleLabel.text = getBanner.title
        contentLabel.text = getBanner.content
        createdLabel.text = getBanner.created_at
    }
    
}
