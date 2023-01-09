//
//  Partner.swift
//  Canow
//
//  Created by TuanBM6 on 10/19/21.
//

import Foundation

struct Partner {
    let errorCode: MessageCode
    let message: String
    let data: [PartnerInfo]?
}

extension Partner: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
