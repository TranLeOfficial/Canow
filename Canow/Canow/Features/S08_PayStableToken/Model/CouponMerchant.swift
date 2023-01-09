//
//  CouponMerchant.swift
//  Canow
//
//  Created by TuanBM6 on 1/4/22.
//

import Foundation

struct CouponMerchant {
    let errorCode: MessageCode
    let message: String
    let data: [CouponMerchantInfo]
}

extension CouponMerchant: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
