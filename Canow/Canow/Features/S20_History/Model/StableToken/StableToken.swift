//
//  StableToken.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import Foundation

struct StableToken {
    let errorCode: MessageCode
    let message: String
    let data: StableTokenInfo
}

extension StableToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
