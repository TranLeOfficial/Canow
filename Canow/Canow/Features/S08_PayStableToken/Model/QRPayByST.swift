//
//  QRPayByST.swift
//  Canow
//
//  Created by PhuNT14 on 25/11/2021.
//

import Foundation

struct QRPayByST {
    let name: String
    let partnerId: Int
    let walletId: String
    let amount: Int?
}

extension QRPayByST: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case partnerId
        case walletId
        case amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        partnerId = try container.decode(Int.self, forKey: .partnerId)
        walletId = try container.decode(String.self, forKey: .walletId)
        amount = try container.decode(Int?.self, forKey: .amount)
    }
}
