//
//  PartnerSport.swift
//  Canow
//
//  Created by TuanBM6 on 12/21/21.
//

import Foundation

struct PartnerSport {
    let errorCode: MessageCode
    let message: String
    let data: [PartnerSportInfo]?
}

extension PartnerSport: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
