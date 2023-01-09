//
//  SignUpViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 12/10/2021.
//

import Foundation

class SignUpViewModel: NSObject {
    
    // MARK: - Properties
    var checkAccountExistedSuccess: () -> Void = { }
    var checkAccountExistedFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension SignUpViewModel {
    
    func checkAccountExist(phone: String) {
        CommonManager.showLoading()
        NetworkManager.shared.checkAccountExist(phone: phone) { [weak self] result in
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
    
    // TODI: temp check phone vietname
    func validatePhoneNumber(phone: String) -> Bool {
        return phone.count == Constants.PHONE_COUNT
    }
    
}
