//
//  ResetPasswordViewModel.swift
//  Canow
//
//  Created by NhanTT13 on 10/24/21.
//

import Foundation

class ResetPasswordViewModel: NSObject {
    
    // MARK: - Properties
    var checkAccountExistedSuccess: () -> Void = { }
    var checkAccountExistedFailure: (String) -> Void = { _ in }
    
}

// MARK: - Forgot password
extension ResetPasswordViewModel {
    
    func checkAccountExist(phone: String) {
        CommonManager.showLoading()
        NetworkManager.shared.checkAccountNotExist(phone: phone) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userData):
                if userData.errorCode != .SUCCESSFUL {
                    self.checkAccountExistedFailure(userData.errorCode.message)
                } else {
                    self.checkAccountExistedSuccess()
                }
            case .failure(let error):
                self.checkAccountExistedFailure(error.message)
            }
        }
    }
    
    func validatePhoneNumber(phone: String) -> Bool {
        return phone.count == Constants.PHONE_COUNT
    }
    
}
