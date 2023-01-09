//
//  ReceiverTransfer.swift
//  Canow
//
//  Created by NhiVHY on 1/5/22.
//

import Foundation

struct ReceiverTransfer {
    let errorCode: MessageCode
    let message: String
    let data: [ReceiverTransferInfo]
}

extension ReceiverTransfer: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
