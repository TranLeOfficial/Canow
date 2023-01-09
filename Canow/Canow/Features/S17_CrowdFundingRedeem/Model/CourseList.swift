//
//  CourseList.swift
//  Canow
//
//  Created by TuanBM6 on 1/11/22.
//

import Foundation

struct CourseList {
    let errorCode: MessageCode
    let message: String
    let data: [CourseListDetail]?
}

extension CourseList: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
