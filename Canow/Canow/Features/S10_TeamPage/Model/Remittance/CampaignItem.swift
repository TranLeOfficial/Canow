//
//  CampaignItem.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation

struct CampaignItem: Decodable {
    let icon: String
    let id: Int
    let name: String
    let price: Int
    let quantity: String
}
