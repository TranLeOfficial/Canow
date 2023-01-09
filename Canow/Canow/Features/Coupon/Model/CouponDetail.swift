//
//  CouponDetail.swift
//  Canow
//
//  Created by TuanBM6 on 12/6/21.
//

import Foundation

struct CouponDetail {
    let errorCode: MessageCode
    let message: String
    let data: CouponDetailInfo
}

extension CouponDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
