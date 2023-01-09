//
//  TopupCard.swift
//  Canow
//
//  Created by TuanBM6 on 11/26/21.
//

import Foundation

struct TopupCard {
    let errorCode: MessageCode
    let message: String
    let data: TopupCardInfo
}

extension TopupCard: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
