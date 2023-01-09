//
//  PartnerInfoById.swift
//  Canow
//
//  Created by NhanTT13 on 10/31/21.
//

import Foundation

struct PartnerInfoById: Decodable {
    let ErrorCode: String
    let Message: String
    let Data: PartnerData?
}
struct PartnerData: Decodable {
    let name: String
    let description: String
    let cover: String
    let logo: String
}
