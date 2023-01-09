//
//  IdToken.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

struct IdToken {
    let token: String
    let payload: PayLoadIdToken
}

extension IdToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case token = "jwtToken"
        case payload
    }
}
