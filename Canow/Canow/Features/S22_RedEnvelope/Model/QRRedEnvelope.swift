//
//  QRRedEnvelope.swift
//  Canow
//
//  Created by Nhi Vo on 25/02/2022.
//

import Foundation

struct QRRedEnvelope {
    let name: String
    let partnerId: Int
    let walletId: String
    let amount: Int?
}

extension QRRedEnvelope: Decodable {
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
