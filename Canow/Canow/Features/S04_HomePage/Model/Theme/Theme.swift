//
//  Theme.swift
//  Canow
//
//  Created by TuanBM6 on 10/8/21.
//

import Foundation

struct Theme {
    let errorCode: MessageCode
    let message: String
    let data: ThemeInfo?
}

extension Theme: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
