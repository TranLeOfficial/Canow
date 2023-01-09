//
//  PayLoadAccessToken.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

struct PayLoadAccessToken {
    let sub: String
    let eventId: String
    let tokenUse: String
    let scope: String
    let authTime: Int
    let iss: String
    let exp: Int
    let iat: Int
    let jti: String
    let clientId: String
    let username: String
}

extension PayLoadAccessToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case sub
        case eventId = "event_id"
        case tokenUse = "token_use"
        case scope
        case authTime = "auth_time"
        case iss
        case exp
        case iat
        case jti
        case clientId = "client_id"
        case username
    }
}
