//
//  KeychainManager.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import KeychainAccess

class KeychainManager {
    
    public static let shared = KeychainManager()
    
    private let keychain = Keychain(service: "Canow-ServiceName")
    
    func getKeychain(forKey keyName: String) -> String? {
        return self.keychain[keyName]
    }
    
    func setKeychain(_ password: String, forKey keyName: String) {
        self.keychain[keyName] = password
    }
    
    func deleteKeychain(forKey keyName: String) {
        self.keychain[keyName] = nil
    }
    
}

extension KeychainManager {
    
    // MARK: - API Token
    public class func setApiAccessToken(token: String) {
        KeychainManager.shared.setKeychain(token, forKey: KeychainKey.accessToken)
    }

    public class func apiAccessToken() -> String? {
        return KeychainManager.shared.getKeychain(forKey: KeychainKey.accessToken)
    }

    public class func deleteApiAccessToken() {
        KeychainManager.shared.deleteKeychain(forKey: KeychainKey.accessToken)
    }

    public class func setApiRefreshToken(token: String) {
        KeychainManager.shared.setKeychain(token, forKey: KeychainKey.refreshToken)
    }

    public class func apiRefreshToken() -> String? {
        return KeychainManager.shared.getKeychain(forKey: KeychainKey.refreshToken)
    }

    public class func deleteApiRefreshToken() {
        KeychainManager.shared.deleteKeychain(forKey: KeychainKey.refreshToken)
    }
    
    public class func setApiIdToken(token: String) {
        KeychainManager.shared.setKeychain(token, forKey: KeychainKey.idToken)
    }

    public class func apiIdToken() -> String? {
        return KeychainManager.shared.getKeychain(forKey: KeychainKey.idToken)
    }

    public class func deleteApiIdToken() {
        KeychainManager.shared.deleteKeychain(forKey: KeychainKey.idToken)
    }
    
    public class func setPhoneNumber(phoneNumber: String) {
        KeychainManager.shared.setKeychain(phoneNumber, forKey: KeychainKey.phoneNumber)
    }

    public class func phoneNumber() -> String? {
        return KeychainManager.shared.getKeychain(forKey: KeychainKey.phoneNumber)
    }

    public class func deletePhoneNumber() {
        KeychainManager.shared.deleteKeychain(forKey: KeychainKey.phoneNumber)
    }
    
    public class func setPassword(password: String) {
        KeychainManager.shared.setKeychain(password, forKey: KeychainKey.passwordLogin)
    }
    
    public class func password() -> String? {
        return KeychainManager.shared.getKeychain(forKey: KeychainKey.passwordLogin)
    }

    public class func deletePassword() {
        KeychainManager.shared.deleteKeychain(forKey: KeychainKey.passwordLogin)
    }
    
}
