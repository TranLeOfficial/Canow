//
//  CrowdFundingDetailInfo.swift
//  Canow
//
//  Created by hieplh2 on 02/12/2021.
//

import Foundation

struct CrowdFundingDetailInfo: Decodable {
    let id: Int
    let category: String
    let teamName: String
    let availableFrom: String
    let status: Status
    let name: String
    let image: String
    let description: String
    let targetAmount: String
    let content: String
    let availableTo: String
    let fantokenLogo: String
    let fantokenTicker: String
    let currentReceivedAmount: Int
    let totalBacker: Int
    let daysLeft: Int
}
