//
//  StableTokenMobile.swift
//  Canow
//
//  Created by TuanBM6 on 11/22/21.
//

import Foundation

struct StableTokenMobile {
    let errorCode: MessageCode
    let message: String
    let data: StableTokenMobileInfo
}

extension StableTokenMobile: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
