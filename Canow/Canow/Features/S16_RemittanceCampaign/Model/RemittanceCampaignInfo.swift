//
//  RemittanceCampaignInfo.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import Foundation

struct RemittanceCampaignInfo: Decodable {
    let availableFrom: String?
    let availableTo: String?
    let category: String?
    let content: String?
    let createBy: String?
    let createdAt: String?
    let daysLeft: Int?
    let description: String?
    let fantokenLogo: String?
    let fantokenTicker: String?
    let id: Int?
    let image: String?
    let name: String?
    let partnerId: Int?
    let status: String?
    let targetAmount: String?
    let totalAmount: String?
    let totalBacker: String?
    let type: String?
    let updateBy: String?
    let updatedAt: String?
}
