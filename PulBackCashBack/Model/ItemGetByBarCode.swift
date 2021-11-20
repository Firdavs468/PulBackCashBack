//
//  ItemGetByBarCode.swift
//  PulBackCashBack
//
//  Created by Firdavs Zokirov  on 20/11/21.
//

import Foundation
struct ItemGetByBarCode {
    var prices : [Prices]
    var name : String
    var in_stock : Int
    var _id : String
    var barCode : String
    var sold_by : String
    var representation : String
    var price : Int
    var sku : Int
    var representation_type : String
}

struct Prices {
    var from : Int
    var price : Int
}
