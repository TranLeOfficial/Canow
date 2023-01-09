//
//  HistoryList.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import Foundation

struct HistoryList: Decodable {
    let list: [HistoryInfo]
    let month: String
}
