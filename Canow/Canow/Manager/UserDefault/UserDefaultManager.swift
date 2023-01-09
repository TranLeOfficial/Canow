//
//  UserDefaultManager.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import Foundation
import Localize

class UserDefaultManager {

    public class func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    public class var themeId: Int? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.themeId) as? Int
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.themeId)
        }
    }
    
    public class var alreadyInstalled: Bool? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.alreadyInstalled) as? Bool
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.alreadyInstalled)
        }
    }
    
    public class var isRemember: Bool? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.isRemeber) as? Bool
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.isRemeber)
        }
    }
    
    public class var transactionId: String? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.transactionId) as? String
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.transactionId)
        }
    }
    
    public class var tokenName: String? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.tokenName) as? String
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.tokenName)
        }
    }
    
    public class var showBalance: Bool? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.showBalance) as? Bool
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.showBalance)
        }
    }
    
    public class var language: String? {
        get {
            return UserDefaults.object(forKey: UserDefaultKey.language) as? String
        }
        set {
            UserDefaults.setObject(newValue, forKey: UserDefaultKey.language)
            Localize.update(language: self.language ?? "ja")
        }
    }
    
}
