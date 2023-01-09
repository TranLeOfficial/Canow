//
//  EcouponInfo.swift
//  Canow
//
//  Created by TuanBM6 on 1/20/22.
//

import Foundation

struct EcouponInfo: Decodable {
    let couponId: String
    let eCouponId: String
    let price: Int
    let couponStatus: String
    let eCouponStatus: String
    let availableTo: String
    let expiredDate: String
    let usableFrom: String?
    let teamId: Int
    let merchantId: Int
    let teamFantokenTicker: String
    let couponName: String
    let merchantName: String
    let merchantLogo: String
    let itemName: String
    let originalPrice: Int
    let payPrice: Int
    let image: String
    let description: String
    let campaignId: Int
    let quantity: Int
    let redeemedQuantity: String
    let remainingQuantity: String
    let campaignStatus: String
    let redeemBy: String
    let couponType: String
    let eventName: String
}
