//
//  CourseListDetail.swift
//  Canow
//
//  Created by hieplh2 on 02/12/2021.
//

import Foundation

struct CourseListDetail: Decodable {
    let couponId: String
    let image: String
    let couponName: String
    let price: String
    let usableFrom: String
    let expiredDate: String
    let fantokenLogo: String
    let merchantName: String
    let couponStatus: String
    let campaignStatus: Status
    let quantity: Int
    let redeemedQuantity: String
    let remainingQuantity: String
}

enum CourseActionType {
    case use, redeem
}
