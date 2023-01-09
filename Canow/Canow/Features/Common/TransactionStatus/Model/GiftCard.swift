//
//  GiftCard.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation

struct GiftCard {
    let errorCode: MessageCode
    let message: String
    let data: GiftCardResultData
}

extension GiftCard: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}

enum GiftCardResultData: Decodable {
    
    case giftCardInfo(GiftCardInfo), data(TransactionResultInfo)
    
    init(from decoder: Decoder) throws {
        if let giftCardInfo = try? decoder.singleValueContainer().decode(GiftCardInfo.self) {
            self = .giftCardInfo(giftCardInfo)
            return
        }
        
        if let data = try? decoder.singleValueContainer().decode(TransactionResultInfo.self) {
            self = .data(data)
            return
        }
        
        throw TransactionResultError.missingValue
    }
    
    enum TransactionResultError: Error {
        case missingValue
    }
    
}

extension GiftCardResultData {
    
    var GiftCardValue: GiftCardInfo? {
        switch self {
        case .giftCardInfo(let value):
            return value
        case .data(_):
            return nil
        }
    }
    
}
