//
//  CrowdfundingInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation

struct CrowdfundingInfo: Decodable {
    let id: Int?
    let image: String?
    let name: String?
    let description: String?
    let targetAmount: String?
    let availableFrom: String?
    let createdAt: String?
    let status: Status
    let availableTo: String?
    let fantokenLogo: String?
    let currentReceivedAmount: String?
    let totalBacker: String?
    let daysLeft: Int?
}

enum Status: String, Decodable {
    case inProgress = "InProgress"
    case closed = "Closed"
}
