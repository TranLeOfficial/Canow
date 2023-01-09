//
//  UniversalLinkData.swift
//  Canow
//
//  Created by TuanBM6 on 3/7/22.
//

import Foundation

enum UniversalLinkType: String, Decodable {
    case redEnvelope = "RedEnvelope"
    case stampRally = "StampRally"
    case stampCard = "StampCard"
}

struct UniversalLinkData {
    let type: UniversalLinkType?
    let creationSource: Int?
    let eventId: Int?
    let checkpointId: Int?
    let stampId: Int?
    let merchantId: Int?
}

extension UniversalLinkData: Decodable {
    enum CodingKeys: String, CodingKey {
        case type
        case creationSource = "~creation_source"
        case eventId
        case checkpointId
        case stampId
        case merchantId
    }
}
