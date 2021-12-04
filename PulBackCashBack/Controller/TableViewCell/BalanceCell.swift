//
//  BalanceCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 02/11/21.
//

import UIKit
import CoreImage

class BalanceCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var balancLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var yourBalanceLabel: UILabel!
    @IBOutlet weak var showCodeButton: UIButton!
    @IBOutlet weak var barCodeNumberLabel: UILabel!
    @IBOutlet weak var barCodeImage: UIImageView!
    @IBOutlet weak var barCodeStack: UIStackView!
    @IBOutlet weak var nameStack: UIStackView!
    
    static func nib() -> UINib {
        return UINib(nibName: "BalanceCell", bundle: nil)
    }
    static let identifier = "BalanceCell"
    var isOpened  = false
    static var userName = Cache.getUserDefaultsString(forKey: Keys.name) + " " + Cache.getUserDefaultsString(forKey: Keys.surname)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        appLanguage()
        barCodeNumberLabel.text = "\(UserDefaults.standard.integer(forKey: Keys.card_id))"
        userNameLabel.text = BalanceCell.userName
        
        //tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
        barCodeImage.image = UIImage(barcode: barCodeNumberLabel.text!)
    }
    
    func appLanguage() {
        yourBalanceLabel.text = AppLanguage.getTitle(type: .myBalanceLbl)
        showCodeButton.setTitle(AppLanguage.getTitle(type: .showCodeLbl), for: .normal)
    }
    
    
    
    //flip card animation
    @IBAction func showCodeButtonPressed(_ sender: Any) {
        if isOpened {
            isOpened = false
            barCodeStack.isHidden = true
            nameStack.isHidden = false
            UIView.transition(with: containerView, duration: 1, options: .transitionFlipFromLeft) { [self] in
                userNameLabel.text = BalanceCell.userName
            }
        }else {
            isOpened = true
            barCodeStack.isHidden = false
            nameStack.isHidden = true
            UIView.transition(with: containerView, duration: 1, options: .transitionFlipFromRight) {
                
            }
        }
    }
    
    //tap gesture
    @objc func cardTapped() {
        if isOpened {
            isOpened = false
            barCodeStack.isHidden = true
            nameStack.isHidden = false
            UIView.transition(with: containerView, duration: 1, options: .transitionFlipFromLeft) {
                
            }
        }else {
            isOpened = true
            barCodeStack.isHidden = false
            nameStack.isHidden = true
            UIView.transition(with: containerView, duration: 1, options: .transitionFlipFromLeft) {
                
            }
        }
    }
    
    func setupUI() {
        //balance label
        balancLabel.textColor = AppColor.appColor
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.47
        balancLabel.attributedText = NSMutableAttributedString(string: "376,650.00", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        //your balance label
        yourBalanceLabel.textColor = UIColor(red: 0.545, green: 0.545, blue: 0.545, alpha: 1)
        paragraphStyle.lineHeightMultiple = 1.38
        // Line height: 30 pt
        
        yourBalanceLabel.attributedText = NSMutableAttributedString(string: "На вашем балансе:", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        //show code Button
        showCodeButton.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        showCodeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        //user name Label
        userNameLabel.textColor = UIColor(red: 0.545, green: 0.545, blue: 0.545, alpha: 1)
        userNameLabel.font = .systemFont(ofSize: 28, weight: .medium)
        
        //container View
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 30
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.systemGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowOpacity = 0.4
    }
    
    func updateCell(balance:String) {
        self.balancLabel.text = balance
    }
    
    
}

class BarcodeGenerator {
    enum Descriptor: String {
        case code128 = "CICode128BarcodeGenerator"
        case pdf417 = "CIPDF417BarcodeGenerator"
        case aztec = "CIAztecCodeGenerator"
        case qr = "CIQRCodeGenerator"
    }
    
    class func generate(from string: String, descriptor: Descriptor, size: CGSize) -> CIImage? {
        let filterName = descriptor.rawValue
        
        guard let data = string.data(using: .ascii),
              let filter = CIFilter(name: filterName) else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let image = filter.outputImage else {
            return nil
        }
        
        let imageSize = image.extent.size
        
        let transform = CGAffineTransform(scaleX: size.width / imageSize.width,
                                          y: size.height / imageSize.height)
        let scaledImage = image.transformed(by: transform)
        
        return scaledImage
    }
}

extension UIImage {
    
    convenience init?(barcode: String) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }
        self.init(ciImage: ciImage)
    }
    
}
