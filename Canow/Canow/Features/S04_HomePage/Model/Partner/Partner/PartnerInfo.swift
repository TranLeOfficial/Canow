//
//  PartnerInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/19/21.
//

import Foundation

struct PartnerInfo: Decodable {
    let partnerId: Int
    let partnerName: String
    let avatar: String
    let ticker: String
    let sportId: Int
    let sportName: String
    let fantokenTicker: String
    let fantokenBalance: Int?
}
