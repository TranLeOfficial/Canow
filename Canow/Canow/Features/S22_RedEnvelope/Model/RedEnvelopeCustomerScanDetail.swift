//
//  RedEnvelopeCustomerScanDetail.swift
//  Canow
//
//  Created by TuanBM6 on 3/2/22.
//

import Foundation

struct RedEnvelopeCustomerScanDetail: Decodable {
    let transactionId: String?
    let rewardType: RewardType?
    let messageContent1: String?
    let messageContent2: String?
    let messageImage: String?
    let amount: Int?
    let tokenLogo: String?
    let eCouponId: String?
    let couponName: String?
}

enum RewardType: String, Decodable {
    case stableToken = "StableToken"
    case coupon = "Coupon"
}
