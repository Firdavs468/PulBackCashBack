//
//  PurchasesTableCell.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 16/11/21.
//

import UIKit

class PurchasesTableCell: UITableViewCell {
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "PurchasesTableCell", bundle: nil)
    }
    static let identifier = "PurchasesTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(createdTime:String, totalPrice:String) {
        self.createdTimeLabel.text = createdTime
        self.totalPriceLabel.text = totalPrice
    }
    
}
