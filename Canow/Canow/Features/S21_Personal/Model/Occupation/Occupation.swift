//
//  Occupation.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation

struct Occupation {
    let errorCode: MessageCode
    let message: String
    let occupation: [OccupationInfo]
}

extension Occupation: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case occupation = "Data"
    }
}
