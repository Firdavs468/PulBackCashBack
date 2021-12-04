//
//  SettingsCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 04/11/21.
//

import UIKit
protocol SettingsDelegate {
    func isOn()
}

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var useTouchIdLbl: UILabel!
    @IBOutlet weak var touchIdSwitch: UISwitch!
    @IBOutlet weak var touchIdLb: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "SettingsCell", bundle: nil)
    }
    static let identifier = "SettingsCell"
    
    let delegate : SettingsDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        useTouchIdLbl.text = AppLanguage.getTitle(type: .useTouchIdLbl)
        touchIdLb.text = AppLanguage.getTitle(type: .touchIdLbl)
    }
    
}
