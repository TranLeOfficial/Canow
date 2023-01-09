//
//  PartnerSportInfo.swift
//  Canow
//
//  Created by TuanBM6 on 12/21/21.
//

import Foundation

struct PartnerSportInfo: Decodable {
    let partnerId: Int?
    let partnerName: String?
    let avatar: String?
    let ticker: String?
    let fantokenTicker: String?
}
