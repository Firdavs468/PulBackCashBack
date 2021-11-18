//
//  AppColor.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 17/11/21.
//

import Foundation
import UIKit
class AppColor {
    static var appColor = UIColor(red: 0.306, green: 0.596, blue: 0.243, alpha: 1)
    
    private init(color:UIColor) {
        AppColor.appColor = color
    }
}
