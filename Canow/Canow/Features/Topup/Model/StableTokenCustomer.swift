//
//  StableTokenCustomer.swift
//  Canow
//
//  Created by NhiVHY on 12/29/21.
//

import Foundation

struct StableTokenCustomer {
    let errorCode: MessageCode
    let message: String
    let data: StableTokenCustomerInfo
}

extension StableTokenCustomer: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
