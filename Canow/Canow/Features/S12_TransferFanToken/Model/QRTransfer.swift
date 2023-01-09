//
//  QRTransfer.swift
//  Canow
//
//  Created by TuanBM6 on 12/1/21.
//

import Foundation

struct QRTransfer {
    let phone: String
}

extension QRTransfer: Decodable {
    enum CodingKeys: String, CodingKey {
        case phone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        phone = try container.decode(String.self, forKey: .phone)
    }
}
