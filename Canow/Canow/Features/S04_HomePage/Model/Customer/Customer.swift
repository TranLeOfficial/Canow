//
//  Customer.swift
//  Canow
//
//  Created by TuanBM6 on 10/20/21.
//

import Foundation

struct Customer {
    let errorCode: MessageCode
    let message: String
    let data: CustomerInfo
}

extension Customer: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
