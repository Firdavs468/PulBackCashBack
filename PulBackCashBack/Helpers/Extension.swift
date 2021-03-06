//
//  Extension+StackView.swift
//  Bananjon
//
//  Created by Firdavs Zokirov  on 11/09/21.
//


import Foundation
import UIKit

//Stack View
extension UIStackView{
    convenience init(views:[UIView], axis:NSLayoutConstraint.Axis, spacing: CGFloat, alignment:UIStackView.Alignment, distribution:UIStackView.Distribution){
        self.init()
        
        for view in views{
            self.addArrangedSubview(view)
        }
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

//Label Attribute text
//Half text color change
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.271, green: 0.741, blue: 0.659, alpha: 1).cgColor, range: range)
        self.attributedText = attribute
    }
}

// saved a photo to the gallery
extension UIViewController {
    func savedGallery() {
        let selectedImage = UIImage() // tanlangan rasm
        let imageData = selectedImage.jpegData(compressionQuality: 0.6)!
        let compressedJPGImage = UIImage(data: imageData)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        let alert = UIAlertView(title: "Wow",
                                message: "Your image has been saved to Photo Library!",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
}
