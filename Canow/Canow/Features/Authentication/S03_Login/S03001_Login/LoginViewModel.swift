//
//  LoginViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation
import UIKit
import Localize

class LoginViewModel: NSObject {
    
    // MARK: - Properties
    var loginSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension LoginViewModel {
    
    func login(username: String, password: String, isRemember: Bool) {
        NetworkManager.shared.login(username: username, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userData):
                if userData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(userData.errorCode.message)
                } else {
                    if userData.data.status != "Active" {
                        self.fetchDataFailure(MessageCode.E008.message)
                    } else {
                        if let idToken = userData.data.idToken?.token, let refreshToken = userData.data.refreshToken?.token, let accessToken = userData.data.accessToken?.token {
                            KeychainManager.setApiIdToken(token: idToken)
                            if isRemember {
                                KeychainManager.setApiRefreshToken(token: refreshToken)
                            }
                            KeychainManager.setApiAccessToken(token: accessToken)
                            KeychainManager.setPhoneNumber(phoneNumber: username)
                            KeychainManager.setPassword(password: password)
                            UserDefaultManager.alreadyInstalled = true
                        }
                        
                        self.getCustomerInfo()
                    }
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    private func getCustomerInfo() {
        NetworkManager.shared.getInfoCustomer { result in
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    DataManager.shared.saveCustomerInfo(customer.data)
                    Localize.update(language: customer.data.language)
                    self.getTheme(customer.data.themeId)
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    private func getTheme(_ themeId: Int) {
        NetworkManager.shared.getThemeById(id: themeId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let theme):
                if theme.errorCode == .SUCCESSFUL {
                    guard let themeInfo = theme.data else {
                        self.fetchDataFailure(MessageCode.E500.message)
                        self.loginSuccess()
                        return
                    }
                    RlmManager.saveTheme(theme: themeInfo)
                    UserDefaultManager.themeId = themeInfo.themeId
                    NotificationCenter.default.post(name: NSNotification.themeChanged, object: themeInfo)
                    NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                    self.loginSuccess()
                } else {
                    self.loginSuccess()
                }
            case .failure(let error):
                self.loginSuccess()
                print(error)
            }
        }
    }
    
}
