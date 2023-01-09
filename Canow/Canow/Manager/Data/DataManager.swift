//
//  DataManager.swift
//  Canow
//
//  Created by hieplh2 on 27/12/2021.
//

import Foundation
import Localize

class DataManager {
    
    // MARK: - Properties
    static let shared = DataManager()
    
    private var customerInfo: CustomerInfo?
    private var merchantInfo: TeamSelectedInfo?
    private var qrData: String?
    private var receiverInfo: ReceiverTransferInfo?
    private var themeInfo: TeamTheme = SpecialTheme.themeDefault
    private var checkTeamPage: FanTokenOrHome?
    private var stableTokenCustommer: StableTokenMobileInfo?
    private var stableTokenDefault: StableTokenInfo?
    private var universalLinkData: UniversalLinkData?
    
    // MARK: - Methods
    func deleteAll() {
        self.deleteCustomerInfo()
        self.deleteMyQR()
        self.deleteReceiverInfo()
        self.deleteMerchantInfo()
        self.deleteTheme()
        self.deleteCheckFantoken()
        self.deleteStableTokenCustomer()
    }
    
}

// MARK: - Customer Info
extension DataManager {
    
    func saveCustomerInfo(_ info: CustomerInfo) {
        self.customerInfo = info
        self.saveTheme(info.themeId)
    }
    
    func getCustomerInfo() -> CustomerInfo? {
        return self.customerInfo
    }
    
    func deleteCustomerInfo() {
        self.customerInfo = nil
    }
    
}

// MARK: - ReceiverTransferInfo
extension DataManager {
    
    func saveReceiverInfo(_ info: ReceiverTransferInfo) {
        self.receiverInfo = info
    }
    
    func getReceiverInfo() -> ReceiverTransferInfo? {
        return self.receiverInfo
    }
    
    func deleteReceiverInfo() {
        self.receiverInfo = nil
    }
    
}
// MARK: - Merchant Info
extension DataManager {
    
    func saveMerchantInfo(_ info: TeamSelectedInfo) {
        self.merchantInfo = info
    }
    
    func getMerchantInfo() -> TeamSelectedInfo? {
        return self.merchantInfo
    }
    
    func deleteMerchantInfo() {
        self.merchantInfo = nil
    }
    
}

// MARK: - My QR
extension DataManager {
    
    func saveMyQR(qr: String) {
        self.qrData = qr
    }
    
    func getMyQR() -> String? {
        return self.qrData
    }
    
    func deleteMyQR() {
        self.qrData = nil
    }
    
}

// MARK: - Check Fantoken or Home
extension DataManager {
    
    func saveCheck(check: FanTokenOrHome) {
        self.checkTeamPage = check
    }
    
    func isFanToken() -> FanTokenOrHome? {
        return self.checkTeamPage
    }
    
    func deleteCheckFantoken() {
        self.checkTeamPage = nil
    }
    
}

// MARK: - Stable token customer
extension DataManager {
    
    func saveStableTokenCustomer(stableToken: StableTokenMobileInfo) {
        self.stableTokenCustommer = stableToken
    }
    
    func getStableTokenCustomer() -> StableTokenMobileInfo? {
        return self.stableTokenCustommer
    }
    
    func deleteStableTokenCustomer() {
        self.stableTokenCustommer = nil
    }
    
}

// MARK: - Stable token default
extension DataManager {
    
    func saveStableTokenDafault(stableToken: StableTokenInfo) {
        self.stableTokenDefault = stableToken
    }
    
    func getStableTokenDefault() -> StableTokenInfo? {
        return self.stableTokenDefault
    }
    
    func deleteStableTokenDefault() {
        self.stableTokenDefault = nil
    }
    
}

// MARK: - UniversalLink
extension DataManager {
    
    func saveUniversalLinkData(universalLinkData: UniversalLinkData) {
        self.universalLinkData = universalLinkData
    }
    
    func getUniversalLinkData() -> UniversalLinkData? {
        return self.universalLinkData
    }
    
    func deleteUniversalLinkData() {
        self.universalLinkData = nil
    }
    
}

// MARK: - Special Theme
extension DataManager {
    
    func saveTheme(_ themeId: Int) {
        if let theme = SpecialTheme.themeData[themeId] {
            self.themeInfo = theme
        } else {
            self.themeInfo = SpecialTheme.themeDefault
        }
        NotificationCenter.default.post(name: NSNotification.themeChanged, object: nil)
    }
    
    func getTheme() -> TeamTheme {
        return self.themeInfo
    }
    
    func deleteTheme() {
        self.themeInfo = SpecialTheme.themeDefault
        NotificationCenter.default.post(name: NSNotification.themeChanged, object: nil)
    }
    
}
