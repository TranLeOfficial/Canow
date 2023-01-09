//
//  OccupationInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation

struct OccupationInfo: Decodable {
    let createdAt: String
    let updatedAt: String
    let createBy: String
    let updateBy: String
    let id: Int
    let name: String
    let isActive: Bool
}
