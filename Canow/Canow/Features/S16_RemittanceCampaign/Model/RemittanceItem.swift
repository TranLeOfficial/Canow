//
//  RemittanceItem.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import Foundation

struct RemittanceItem {
    let errorCode: MessageCode
    let message: String
    let data: [RemittanceItemInfo]
}

extension RemittanceItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
