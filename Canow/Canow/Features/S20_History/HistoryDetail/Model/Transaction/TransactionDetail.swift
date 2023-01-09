//
//  TransactionDetail.swift
//  Canow
//
//  Created by TuanBM6 on 11/8/21.
//

import Foundation

struct TransactionDetail: Decodable {
    let transactionId: String?
    let transactionType: TransactionType?
    let createdAt: String?
    let amount: Int?
    let tokenType: String?
    let tokenLogo: String?
    let status: TransactionStatus?
    let merchantName: String?
    let merchantLogo: String?
    let teamName: String?
    let teamLogo: String?
    let couponName: String?
    let couponImage: String?
    let itemName: String?
    let giftCardId: String?
    let fromCustomer: String?
    let toCustomer: String?
    let campaignName: String?
    let campaignItemName: String?
    let campaignItemLogo: String?
    let reason: String?
    let eventName: String?
}

enum TransactionStatus: String, Decodable {
    case completed = "Completed"
    case failed = "Failed"
    case pending = "Pending"
    
    var message: String {
        switch self {
        case .completed:
            return StringConstants.s07LbSuccessful.localized
        case .failed:
            return StringConstants.s04TransactionFail.localized
        case .pending:
            return StringConstants.s07LbProcessing.localized
        }
    }
}
