//
//  TopupCardInfo.swift
//  Canow
//
//  Created by TuanBM6 on 11/26/21.
//

import Foundation

class TopupCardInfo: Decodable {
    let createdAt: String?
    let updatedAt: String?
    let createBy: String?
    let updateBy: String?
    let id: Int?
    let company: String?
    let externalId: String?
    let externalLink: String?
    let processDate: String?
    let transactionId: String?
    let amount: Int?
    let username: String?
    let status: String?
    let linkUrlResult: String?
    let paymentResult: String?
    let changePaymentResult: String?
    let isConfirm: Bool?
    let accessId: String?
    let accessPass: String?
}
