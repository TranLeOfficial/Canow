//
//  Redeem.swift
//  Canow
//
//  Created by hieplh2 on 06/12/2021.
//

import Foundation

struct Redeem {
    let errorCode: MessageCode
    let message: String
    let data: String
}

extension Redeem: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
