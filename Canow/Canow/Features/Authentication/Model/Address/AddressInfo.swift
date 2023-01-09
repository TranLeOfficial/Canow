//
//  DataAddress.swift
//  Canow
//
//  Created by PhuNT14 on 21/10/2021.
//

import Foundation

struct AddressInfo {
    let createdAt: String
    let updatedAt: String
    let createBy: String
    let updateBy: String
    let id: Int
    let name: String
    let isActive: Bool
}

extension AddressInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case createdAt
        case updatedAt
        case createBy
        case updateBy
        case id
        case name
        case isActive
    }
}
