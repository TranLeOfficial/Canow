//
//  RemittanceCampaign.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import Foundation

struct RemittanceCampaign {
    let errorCode: MessageCode
    let message: String
    let data: RemittanceCampaignInfo
}

extension RemittanceCampaign: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
