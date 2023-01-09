//
//  RedEnvelopeCustomerScan.swift
//  Canow
//
//  Created by TuanBM6 on 3/2/22.
//

import Foundation

struct RedEnvelopeCustomerScan {
    let errorCode: MessageCode
    let message: String
    let data: RedEnvelopeCustomerScanDetail
}

extension RedEnvelopeCustomerScan: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
