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
    
    @IBOutlet weak var touchIdSwitch: UISwitch!
    static func nib() -> UINib {
        return UINib(nibName: "SettingsCell", bundle: nil)
    }
    static let identifier = "SettingsCell"
    
    let delegate : SettingsDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
