//
//  CustomerInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/20/21.
//

import Foundation

struct CustomerInfo: Decodable {
    let userName: String
    let fullname: String
    let gender: String
    let birthday: String?
    let address: String?
    let occupation: String?
    let teamId: Int
    let team: String
    let sport: String
    let avatar: String?
    let language: String
    let status: String
    let sportId: Int
    let themeId: Int
    let listWallet: [Wallet]
}
