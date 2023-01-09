//
//  TeamInfo.swift
//  Canow
//
//  Created by PhuNT14 on 26/10/2021.
//

import Foundation

struct TeamInfo: Decodable {
    let createdAt: String
    let updatedAt: String
    let createBy: String
    let updateBy: String
    let id: Int
    let name: String
    let partnerType: String
    let sportId: Int
    let ticker: String
    let avatar: String
    let isActive: Bool
    let themeId: Int
    let description: String
    let addressId: Int
    let cover: String
    let stableTokenName: String
}
