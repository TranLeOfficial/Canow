//
//  Crowdfunding.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation

struct Crowdfunding {
    let errorCode: MessageCode
    let message: String
    let data: [CrowdfundingInfo]?
}

extension Crowdfunding: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
