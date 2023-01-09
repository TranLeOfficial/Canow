//
//  Account.swift
//  Canow
//
//  Created by TuanBM6 on 12/20/21.
//

import Foundation

struct CommonResponse {
    let errorCode: MessageCode
    let message: String
}

extension CommonResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
    }
}
