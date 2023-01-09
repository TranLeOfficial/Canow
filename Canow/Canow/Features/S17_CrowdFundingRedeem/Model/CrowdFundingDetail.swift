//
//  CrowdFundingDetail.swift
//  Canow
//
//  Created by hieplh2 on 02/12/2021.
//

import Foundation

struct CrowdFundingDetail {
    let errorCode: MessageCode
    let message: String
    let data: CrowdFundingDetailInfo
}

extension CrowdFundingDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
