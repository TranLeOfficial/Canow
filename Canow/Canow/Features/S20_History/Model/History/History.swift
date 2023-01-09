//
//  History.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import Foundation

struct History {
    let errorCode: MessageCode
    let message: String
    let data: [HistoryInfo]
}

extension History: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
