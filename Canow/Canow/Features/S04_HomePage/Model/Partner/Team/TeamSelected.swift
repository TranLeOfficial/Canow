//
//  TeamSelected.swift
//  Canow
//
//  Created by TuanBM6 on 11/4/21.
//

import Foundation

struct TeamSelected {
    let errorCode: MessageCode
    let message: String
    let data: TeamSelectedInfo
}

extension TeamSelected: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
