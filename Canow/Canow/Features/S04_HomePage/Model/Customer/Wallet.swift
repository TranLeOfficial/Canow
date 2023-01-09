//
//  Wallet.swift
//  Canow
//
//  Created by TuanBM6 on 10/20/21.
//

import Foundation

struct Wallet: Decodable {
    let walletId: String
    let tokenType: String
    let tokenName: String
    let balance: Int
}
