//
//  PurchasedInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation

struct PurchasedInfo: Decodable {
    let couponId: String
    let eCouponId: String
    let image: String
    let couponName: String
    let price: String
    let expiredDate: String
    let fantokenTicker: String
    let merchantName: String
    let type: String
    let availableFrom: String
    let usableFrom: String?
}
