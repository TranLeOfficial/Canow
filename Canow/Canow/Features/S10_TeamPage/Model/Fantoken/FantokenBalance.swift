//
//  FantokenBalance.swift
//  Canow
//
//  Created by TuanBM6 on 11/4/21.
//

import Foundation

struct FantokenBalance {
    let errorCode: MessageCode
    let message: String
    let data: FantokenResultData
}

extension FantokenBalance: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}

enum FantokenResultData: Decodable {
    
    case fantokenBalanceInfo(FantokenBalanceInfo), data(TransactionResultInfo)
    
    init(from decoder: Decoder) throws {
        if let fantokenInfo = try? decoder.singleValueContainer().decode(FantokenBalanceInfo.self) {
            self = .fantokenBalanceInfo(fantokenInfo)
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

extension FantokenResultData {
    
    var FantokenValue: FantokenBalanceInfo? {
        switch self {
        case .fantokenBalanceInfo(let value):
            return value
        case .data(_):
            return nil
        }
    }
    
}
