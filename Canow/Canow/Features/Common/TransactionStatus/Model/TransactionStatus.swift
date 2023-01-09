//
//  TransactionStatus.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation

struct TransactionStatusRedeem {
    let errorCode: MessageCode
    let message: String
    let data: TransactionStatusRedeemInfo
}

struct TransactionStatusRedeemInfo: Decodable {
    let amount: Int?
    let id: String?
    let status: TransactionStatus?
    let createdAt: String?
}

extension TransactionStatusRedeem: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
