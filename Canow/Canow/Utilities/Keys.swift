//
//  Keys.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import Foundation

public struct KeychainKey {
    static let accessToken = "ACCESS_TOKEN",
               refreshToken = "REFRESH_TOKEN",
               idToken = "ID_TOKEN",
               phoneNumber = "PHONE_NUMBER",
               passwordLogin = "PASSWORD_LOGIN"
}

public struct UserDefaultKey {
    static let themeId = "THEME_ID",
               alreadyInstalled = "ALREADY_INSTALLED",
               isRemeber = "IS_REMEMBER",
               transactionId = "TRANSACTION_ID",
               tokenName = "TOKEN_NAME",
               showBalance = "SHOW_BALANCE",
               language = "LANGUAGE"
}

extension NSNotification {
    static let themeChanged = NSNotification.Name("NOTIFY_THEME_CHANGED"),
               registerSuccess = NSNotification.Name("NOTIFY_REGISTER_SUCCESS"),
               tabBarChanged = NSNotification.Name("NOTIFY_TAB_BAR_CHANGED"),
               authenticateError = NSNotification.Name("AUTHENTICATE_EROR"),
               backHomePage = NSNotification.Name("BACK_HOME_PAGE"),
               Login = NSNotification.Name("LOGIN"),
               universalLink = NSNotification.Name("UNIVERSAL_LINK")
}
