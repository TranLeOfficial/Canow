//
//  TopupViewModel.swift
//  Canow
//
//  Created by NhiVHY on 12/29/21.
//

import Foundation

class TopupViewModel: NSObject {
    
    // MARK: - Properties
    var fetchDataSuccess: (StableTokenCustomerInfo) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension TopupViewModel {
    
    func getStableTokenCustomer() {
        guard let phoneNumber = KeychainManager.phoneNumber() else {
            return
        }
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableTokenCustomer):
                if stableTokenCustomer.errorCode == .SUCCESSFUL {
                    self.fetchDataSuccess(stableTokenCustomer.data)
                } else {
                    self.fetchDataFailure(stableTokenCustomer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
