//
//  CourseDetail.swift
//  Canow
//
//  Created by hieplh2 on 06/12/2021.
//

import Foundation

struct CourseDetail {
    let errorCode: MessageCode
    let message: String
    let data: CourseDetailInfo
}

extension CourseDetail: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
