//
//  TopupGiftCard.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation

struct TransactionResult {
    let errorCode: MessageCode
    let message: String
    let data: TransactionResultData
}

extension TransactionResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}

struct TransactionResultInfo: Decodable { }

enum TransactionResultData: Decodable {
    
    case string(String), data(TransactionResultInfo)
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
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

extension TransactionResultData {
    
    var stringValue: String {
        switch self {
        case .string(let value):
            return value
        case .data(_):
            return ""
        }
    }
    
}
