//
//  CouponMerchantInfo.swift
//  Canow
//
//  Created by TuanBM6 on 1/4/22.
//

import Foundation

struct CouponMerchantInfo: Decodable {
    let eCouponId: String
    let image: String
    let couponName: String
    let payPrice: String
    let expiredDate: String
    let fantokenTicker: String
    let merchantName: String
    let type: String
    let usableFrom: String?
}
