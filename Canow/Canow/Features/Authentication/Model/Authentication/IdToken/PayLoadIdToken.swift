//
//  PayLoadIdToken.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

struct PayLoadIdToken {
    let sub: String
    let aud: String
    let eventId: String
    let tokenUse: String
    let authTime: Int
    let iss: String
    let phoneNumberVerified: Bool
    let cognitoUsername: String
    let phoneNumber: String
    let exp: Int
    let iat: Int
}

extension PayLoadIdToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case sub
        case aud
        case eventId = "event_id"
        case tokenUse = "token_use"
        case authTime = "auth_time"
        case iss
        case phoneNumberVerified = "phone_number_verified"
        case cognitoUsername = "cognito:username"
        case phoneNumber = "phone_number"
        case exp
        case iat
    }
}
