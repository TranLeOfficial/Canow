//
//  Sport.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation

struct Sport {
    let errorCode: MessageCode
    let message: String
    let sport: [SportInfo]
}

extension Sport: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case sport = "Data"
    }
}
