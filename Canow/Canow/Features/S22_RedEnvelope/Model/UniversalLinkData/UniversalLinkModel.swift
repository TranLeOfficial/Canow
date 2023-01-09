//
//  UniversalLinkModel.swift
//  Canow
//
//  Created by NhiVHY on 07/03/2022.
//

import Foundation

struct UniversalLinkModel {
    let errorCode: MessageCode
    let message: String
    let data: UniversalLinkMiddleData
}

extension UniversalLinkModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
