//
//  CouponInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation

struct CouponInfo: Decodable {
    let couponId: String
    let eCouponId: String
    let image: String
    let couponName: String
    let price: String
    let availableFrom: String
    let createdAt: String
    let availableTo: String
    let expiredDate: String
    let fantokenTicker: String
    let merchantName: String
    let quantity: Int
    let redeemedQuantity: String
}
