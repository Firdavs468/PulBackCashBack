//
//  AlertView.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 27/11/21.
//

import Foundation
import UIKit

class CustomAlert {
    class func showAlert(title: String, titleColor: UIColor, message: String, preferredStyle: UIAlertController.Style, titleAction: String, actionStyle: UIAlertAction.Style, vc: UIViewController) {
        
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: titleColor])
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        alert.addAction(UIAlertAction(title: titleAction, style: actionStyle, handler: nil))
        vc.present(alert, animated: true)
    }
}

