//
//  User.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

struct Authentication {
    let errorCode: MessageCode
    let message: String
    let data: AuthenticationInfo
}

extension Authentication: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
