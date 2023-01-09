//
//  Common.swift
//  Canow
//
//  Created by PhuNT14 on 26/10/2021.
//

import Foundation

enum Gender: Int {
    case male = 0, female, other
    
    var value: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        }
    }
    
    var valueLocalize: String {
        switch self {
        case .male:
            return StringConstants.s01BtnMale.localized
        case .female:
            return StringConstants.s01BtnFemale.localized
        case .other:
            return StringConstants.s01BtnOther.localized
        }
    }
}

struct CommonData {
    let errorCode: MessageCode
    let message: String
    let data: String
}

extension CommonData: Decodable {
    enum CodingKeys: String, CodingKey {
        case errorCode = "ErrorCode"
        case message = "Message"
        case data = "Data"
    }
}
