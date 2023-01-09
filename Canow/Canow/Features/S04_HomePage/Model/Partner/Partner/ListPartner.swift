//
//  ListPartner.swift
//  Canow
//
//  Created by TuanBM6 on 10/22/21.
//

import Foundation

class ListPartner: Decodable {
    var list: [PartnerInfo]? = []
    var sportName: Sports = .others
    var sportId: Int = 0
    
}

enum Sports: String, Decodable {
    case football = "FOOTBALL"
    case baseball = "BASEBALL"
    case tennis = "TENNIS"
    case basketball = "BASKETBALL"
    case tableTennis = "TABLE_TENNIS"
    case rugby = "RUGBY"
    case swimming = "SWIMMING"
    case badminton = "BADMINTON"
    case volleyball = "VOLLEYBALL"
    case lacrosse = "LACROSSE"
    case dance = "DANCE"
    case futsal = "FUTSAL"
    case others = "OTHERS"
    
    var message: String {
        return self.rawValue.localized
    }
}
