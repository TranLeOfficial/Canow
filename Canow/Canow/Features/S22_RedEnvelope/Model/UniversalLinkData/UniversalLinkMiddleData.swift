//
//  UniversalLinkMiddleData.swift
//  Canow
//
//  Created by NhiVHY on 07/03/2022.
//

import Foundation

struct UniversalLinkMiddleData {
    let universalLinkData: UniversalLinkData?
    let type: Int?
}

extension UniversalLinkMiddleData: Decodable {
    enum CodingKeys: String, CodingKey {
        case universalLinkData = "data"
        case type
    }
}
