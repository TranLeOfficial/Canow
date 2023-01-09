//
//  AccessToken.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

struct AccessToken {
    let token: String
    let payload: PayLoadAccessToken
}

extension AccessToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case token = "jwtToken"
        case payload
    }
}
