//
//  NewsDetailInfo.swift
//  Canow
//
//  Created by PhuNT14 on 14/11/2021.
//

import Foundation

struct NewDetailInfo: Decodable {
    let createdAt: String
    let updatedAt: String
    let createBy: String
    let updateBy: String
    let id: Int
    let name: String
    let description: String
    let content: String
    let availableFrom: String
    let availableTo: String
    let status: String
    let image: String
}
