//
//  CouponDetailInfo.swift
//  Canow
//
//  Created by TuanBM6 on 12/6/21.
//

import Foundation

struct CouponDetailInfo: Decodable {
    let availableTo: String
    let campaignId: Int
    let campaignStatus: String
    let couponId: String
    let couponName: String
    let couponStatus: String
    let couponType: CouponType
    let description: String
    let eCouponId: String
    let eCouponStatus: String
    let eventName: String
    let expiredDate: String
    let image: String
    let itemName: String
    let merchantId: Int
    let merchantLogo: String
    let merchantName: String
    let originalPrice: Int
    let payPrice: Int
    let price: Int
    let redeemBy: String
    let remainingQuantity: String
    let teamFantokenTicker: String
    let teamId: Int
    let usableFrom: String?
    let redeemedQuantity: String
    let quantity: Int
}

enum CouponType: String, Decodable {
    case course = "Course"
    case coupon = "Coupon"
    case redEnvelopeCoupon = "RedEnvelopeCoupon"
    case airdropCoupon = "AirdropCoupon"
}
