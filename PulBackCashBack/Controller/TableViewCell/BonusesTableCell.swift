//
//  BonusesTableCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 16/11/21.
//

import UIKit

class BonusesTableCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    static func nib() -> UINib {
        return UINib(nibName: "BonusesTableCell", bundle: nil)
    }
    static let identifier = "BonusesTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(value:String, createdTime:String) {
        self.valueLabel.text = value
        self.createdTimeLabel.text = createdTime
    }
    
}
