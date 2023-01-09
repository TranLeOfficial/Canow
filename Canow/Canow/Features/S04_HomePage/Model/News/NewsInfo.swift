//
//  NewsInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/8/21.
//

import Foundation

struct NewsInfo: Decodable {
    let id: Int
    let name: String
    let availableFrom: String
    let image: String
}
