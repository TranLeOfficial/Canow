//
//  Constants.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import Foundation
import UIKit

public struct Constants {
    static let PHONE_COUNT: Int = {
        switch App.environment {
        case .development, .qa:
            return 10
        case .uat, .production:
            return 11
        }
    }()
    
    static let DEEP_LINK_URL: String = {
        switch App.environment {
        case .development:
            return ""
        case .qa, .uat:
            return "https://yelltum.test-app.link/"
        case .production:
            return "https://yelltum.app.link/"
        }
    }()
}

public struct Version {
    // swiftlint:disable identifier_name
    static let REALM_VERSION: UInt64 = 1
}

public struct ScreenSize {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width,
               screenHeight: CGFloat = UIScreen.main.bounds.height,
               displayScaleWidth: CGFloat = ScreenSize.screenWidth < 428.0 ? ScreenSize.screenWidth / 428.0 : 1,
               displayScaleHeight: CGFloat = ScreenSize.screenHeight < 926.0 ? ScreenSize.screenHeight / 926.0 : 1
}

public struct DateFormat {
    static let DATE_FORMAT_DEFAULT = "yyyy/MM/dd HH:mm",
               DATE_DEFAULT_WITHOUT_TIME = "dd/MM/yyyy",
               DATE_CURRENT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
               DATE_ONLY_DAY = "dd",
               DATE_ONLY_MONTH = "MM",
               DATE_ONLY_YEAR = "yyyy",
               DATE_NEWS_FORMAT = "HH:mm - dd/MM/yyyy",
               DATE_PROFILE = "yyyy / MM / dd",
               DATE_SIGNUP = "yyyy-MM-dd",
               DATE_IMAGE = "yyyyMMddHHmmss",
               DATE_FORMAT_COUPON = "yyyy-MM-dd - HH:mm",
               DATE_FORMAT_CROWDFUNDING = "yyyy/MM/dd"
}
