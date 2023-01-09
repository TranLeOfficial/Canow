//
//  SportInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation

struct SportInfo: Decodable {
    let createdAt: String
    let updatedAt: String
    let createBy: String
    let updateBy: String
    let id: Int
    let name: Sports
    let isActive: Bool
    let order: Int
}
