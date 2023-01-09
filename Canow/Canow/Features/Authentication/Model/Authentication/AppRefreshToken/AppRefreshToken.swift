//
//  AppRefreshToken.swift
//  Canow
//
//  Created by hieplh2 on 08/12/2021.
//

import Foundation

struct AppRefreshToken {
    let errorCode: MessageCode
    let message: String
    let data: AppRefreshTokenInfo
}

extension AppRefreshToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
