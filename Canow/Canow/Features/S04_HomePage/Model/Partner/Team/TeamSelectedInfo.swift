//
//  TeamSelectedInfo.swift
//  Canow
//
//  Created by TuanBM6 on 11/4/21.
//

import Foundation

struct TeamSelectedInfo: Decodable {
    let id: Int
    let name: String
    let ticker: String?
    let type: PartnerType?
    let description: String?
    let status: PartnerStatus?
    let addressId: Int?
    let addressName: String?
    let sportId: Int?
    let sport: String?
    let themeId: Int?
    let themeName: String?
    let logo: String
    let cover: String?
    let stableTokenName: String?
    let stableTokenWalletId: String?
    let stableTokenBalance: Int?
    let fantokenWalletId: String?
    let fanTokenBalance: Int
    let fantokenTicker: String
    let fantokenLogo: String?
    let fantokenName: String?
    let supporter: String?
    let isDefaultStableTokenName: Bool?
    
}

enum PartnerType: String, Decodable {
    case team = "Team"
    case merchant = "Merchant"
}

enum PartnerStatus: String, Decodable {
    case active = "Active"
    case inActive = "InActive"
}
