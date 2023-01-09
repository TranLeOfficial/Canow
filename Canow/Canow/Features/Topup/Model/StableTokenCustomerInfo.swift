//
//  StableTokenCustomerInfo.swift
//  Canow
//
//  Created by NhiVHY on 12/29/21.
//

import Foundation

struct StableTokenCustomerInfo {
    let name: String?
    let accountStatus: String?
    let walletId: String?
    let balance: Int?
    let avatar: String?
    let isWhite: Bool?
}

extension StableTokenCustomerInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case accountStatus
        case walletId
        case balance
        case avatar
        case isWhite = "isWhiteList"
    }
}
