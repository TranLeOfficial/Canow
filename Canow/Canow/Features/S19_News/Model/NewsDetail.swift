//
//  NewsDetail.swift
//  Canow
//
//  Created by PhuNT14 on 14/11/2021.
//

import Foundation
import Alamofire

struct NewDetail {
    let errorCode: MessageCode
    let message: String
    let data: NewDetailInfo?
}

extension NewDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
