//
//  RemittanceInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation

struct RemittanceInfo: Decodable {
    let availableFrom: String
    let availableTo: String
    let createdAt: String
    let daysLeft: Int
    let fantokenLogo: String
    let id: Int
    let image: String
    let name: String
    let totalAmount: String
    let totalBacker: String
    let listCampaignItem: [CampaignItem]
}
