//
//  Alert.swift
//  Bananjon
//
//  Created by Firdavs Zokirov  on 09/09/21.
//

import Foundation
import SnapKit
let isSmalScreen568 = Int(UIScreen.main.bounds.height) <= 568
let isSmalScreen736 = UIScreen.main.bounds.height <= 736 && UIScreen.main.bounds.height > 568
class AlertView: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.5
    }
}

class Alert {
    
    enum AlertType {
        case warning
        case success
        case error
        case unknown
    }

    static var timer : Timer? = nil
    
    class func showAlert(forState: AlertType, message: String, duration: TimeInterval = 4, userInteration: Bool = true) {
        
        let alertView = UIView()
        if isSmalScreen568 {
            alertView.frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height-40, width: UIScreen.main.bounds.width-20, height: 60)
        }
        else{
            alertView.frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height-70, width: UIScreen.main.bounds.width-20, height: 80)
        }
        
        alertView.layer.cornerRadius = 20
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowRadius = 6
        alertView.layer.shadowOffset = CGSize(width: 0, height: 3)
        alertView.clipsToBounds = true
        
        let closeBtn = UIButton()
        closeBtn.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            closeBtn.setImage(UIImage(systemName: "x.circle")!.withRenderingMode(.alwaysTemplate), for: .normal)
            closeBtn.tintColor = .white
            closeBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            alertView.addSubview(closeBtn)
            closeBtn.snp.makeConstraints { (make) in
                if isSmalScreen568{
                    make.bottom.equalToSuperview().offset(-8)
                    make.top.equalToSuperview().offset(8)
                    make.right.equalToSuperview().offset(-15)
                }else{
                    make.bottom.equalToSuperview().offset(-17)
                    make.top.equalToSuperview().offset(17)
                    make.right.equalToSuperview().offset(-30)
                }
                make.width.equalTo(50)
            }
        } else {
            // Fallback on earlier versions
        }
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        alertView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if isSmalScreen568{
                make.left.top.equalToSuperview().offset(10)
            }else{
                make.left.top.equalToSuperview().offset(20)
            }
//            make.right.equalTo(closeBtn.snp.left).offset(-5)
//            make.bottom.equalToSuperview().offset(-5)
        }
        alertView.tag = 9981
        
        alertView.backgroundColor = .black
        
        if let window = UIApplication.shared.keyWindow {
            if let vi = UIApplication.shared.keyWindow?.viewWithTag(9981) {
                timer?.invalidate()
                vi.removeFromSuperview()
            }
            window.addSubview(alertView)
            
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            alertView.transform = CGAffineTransform(translationX: 0, y: alertView.frame.height)
        })
        

        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        
        titleLabel.text = message
        
        switch forState {
            case .warning:
                alertView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case .error:
                alertView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            case .success:
                alertView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .unknown:
                alertView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            if let window = UIApplication.shared.keyWindow, let view = window.viewWithTag(9981) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                    view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
                }) { (_) in
                    view.removeFromSuperview()
                }
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Alert.closeBtnPressed), userInfo: nil, repeats: false)
        
    }
    
    
    @objc class func closeBtnPressed() {
        if let window = UIApplication.shared.keyWindow, let view = window.viewWithTag(9981) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                view.transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
            }) { (_) in
                view.removeFromSuperview()
            }
        }
    }
    
}
