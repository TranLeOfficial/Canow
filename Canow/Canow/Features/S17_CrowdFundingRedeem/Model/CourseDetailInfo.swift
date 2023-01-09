//
//  CourseDetailInfo.swift
//  Canow
//
//  Created by hieplh2 on 06/12/2021.
//

import Foundation

struct CourseDetailInfo: Decodable {
    let couponId: String
    let price: Int
    let couponStatus: String
    let availableTo: String
    let expiredDate: String
    let usableFrom: String
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
    let campaignStatus: Status
}
