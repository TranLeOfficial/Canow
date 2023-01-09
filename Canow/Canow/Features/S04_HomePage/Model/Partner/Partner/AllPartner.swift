//
//  AllPartner.swift
//  Canow
//
//  Created by TuanBM6 on 10/22/21.
//

import Foundation

struct AllPartner {
    let errorCode: MessageCode
    let message: String
    let data: [ListPartner]?
}

extension AllPartner: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
