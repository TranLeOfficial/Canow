//
//  EcouponDetail.swift
//  Canow
//
//  Created by TuanBM6 on 1/20/22.
//

import Foundation

struct EcouponDetail {
    let errorCode: MessageCode
    let message: String
    let data: EcouponInfo
}

extension EcouponDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
