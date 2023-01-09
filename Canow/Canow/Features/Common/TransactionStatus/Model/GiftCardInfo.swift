//
//  GiftCardInfo.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation

struct GiftCardInfo: Decodable {
    let amount: Int?
    let createBy: String?
    let createdAt: String?
    let expiryDate: String?
    let genCode: String?
    let giftCardStatus: String?
    let id: String?
    let updateBy: String?
    let updatedAt: String?
}
