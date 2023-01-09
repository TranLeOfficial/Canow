//
//  ThemeInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/8/21.
//

import Foundation
import RealmSwift

@objcMembers
class ThemeInfo: Object, Decodable {
    dynamic var themeId = 0
    dynamic var themeType = ""
    dynamic var status = ""
    dynamic var stableTokenLogo = ""
    dynamic var partnerName = ""
    dynamic var name = ""
    dynamic var mainTextColor = ""
    dynamic var mainBackgroundColor = ""
    dynamic var image = ""
    dynamic var headerTextColor = ""
    dynamic var headerBackgroundColor = ""
    dynamic var footerTextColor = ""
    dynamic var footerBackgroundColor = ""
    dynamic var buttonTextColor = ""
    dynamic var buttonColor = ""
    
    override class func primaryKey() -> String? {
        return "themeId"
    }
    
}
