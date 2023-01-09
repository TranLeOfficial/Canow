//
//  Transaction.swift
//  Canow
//
//  Created by TuanBM6 on 11/8/21.
//

import Foundation

struct Transaction {
    let errorCode: MessageCode
    let message: String
    let data: TransactionDetail
}

extension Transaction: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
