//
//  Address.swift
//  Canow
//
//  Created by PhuNT14 on 21/10/2021.
//

import Foundation

struct UserAddress {
    let errorCode: MessageCode
    let message: String
    let address: [AddressInfo]
}

extension UserAddress: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case address = "Data"
    }
}
