//
//  Team.swift
//  Canow
//
//  Created by PhuNT14 on 26/10/2021.
//

import Foundation

struct TeamList {
    let errorCode: MessageCode
    let message: String
    let data: [TeamInfo]
}

extension TeamList: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
