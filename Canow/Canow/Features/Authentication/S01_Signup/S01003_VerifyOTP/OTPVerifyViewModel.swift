//
//  OTPVerifyViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 13/10/2021.
//

import Foundation

class OTPVerifyViewModel: NSObject {
    
    // MARK: - Properties
    var userDataInfo: AuthenticationInfo?
    var setPasswordSuccess: () -> Void = { }
    var otpVerifySuccess: () -> Void = { }
    var otpResendSuccess: () -> Void = { }
    var confirmForgotPasswordSuccess: () -> Void = {}
    var fetchDataSuccess: () -> Void = {  }
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension OTPVerifyViewModel {
    
    func verifyOTP(phone: String, otp: String) {
        CommonManager.showLoading()
        NetworkManager.shared.verifyOTP(phone: phone, otp: otp) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userData):
                if userData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(userData.errorCode.message)
                } else {
                    self.otpVerifySuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func sendOTPRegister(phone: String) {
        NetworkManager.shared.sendOTPRegister(phone: phone) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userData):
                if userData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(userData.errorCode.message)
                } else {
                    self.fetchDataSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func resendOTP(phone: String) {
        NetworkManager.shared.resendOTP(phone: phone) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userData):
                if userData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(userData.errorCode.message)
                } else {
                    self.otpResendSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func firstSetPassword(phone: String, password: String) {
        NetworkManager.shared.firstSetPassword(username: phone,
                                               password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userData):
                if userData.errorCode != .SUCCESSFUL {
                    self.userDataInfo = userData.data
                    self.fetchDataFailure(userData.errorCode.message)
                } else {
                    self.userDataInfo = userData.data
                    self.setPasswordSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func resendOTPForgot(_ username: String) {
        NetworkManager.shared.forgotPassword(username: username,
                                             isResetOTP: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.localizedDescription)
            }
        }
    }
    
    func setPassword(otp: String, username: String, password: String) {
        CommonManager.showLoading()
        NetworkManager.shared.confirmForgotPassword(otp: otp,
                                                    username: username,
                                                    password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.confirmForgotPasswordSuccess()
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.localizedDescription)
            }
        }
    }
    
    func forgotPassword(_ username: String) {
        NetworkManager.shared.forgotPassword(username: username,
                                             isResetOTP: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.localizedDescription)
            }
        }
    }
    
}
