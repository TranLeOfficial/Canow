//
//  RemittanceItemInfo.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import Foundation

struct RemittanceItemInfo: Decodable {
    let createBy: String?
    let createdAt: String?
    let icon: String?
    let id: Int?
    let isActive: Bool?
    let name: String?
    let price: Int?
    let updateBy: String?
    let updatedAt: String?
}
