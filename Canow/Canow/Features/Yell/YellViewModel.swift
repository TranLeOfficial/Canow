//
//  YellViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 17/11/2021.
//

import Foundation

class YellViewModel: NSObject {
    
    // MARK: - Properties
    var myQRData = String()
    var stableTokenDefault: StableTokenInfo?
    var getMyQRSuccess: () -> Void = { }
    var getStableTokenSuccess: (String) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
    
    var stableToken: StableTokenMobileInfo?
    var getStableMobileInfSuccess: () -> Void = { }
    var getStableMobileDefaultSuccess: () -> Void = { }

}

// MARK: - Methods
extension YellViewModel {
    
    func fetchData() {
        self.getMyQR()
        self.getStableToken()
        self.getStableTokenCustomerMobile()
    }
    
    func getCustomerInfo() -> CustomerInfo? {
        return DataManager.shared.getCustomerInfo()
    }
    
    private func getStableToken() {
        guard let phone = self.getCustomerInfo()?.userName else { return }
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phone) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.getStableTokenSuccess(String(customer.data.balance ?? 0).formatPrice())
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    private func getMyQR() {
        if let qr = DataManager.shared.getMyQR() {
            self.myQRData = qr
            self.getMyQRSuccess()
        } else {
            self.requestQR()
        }
    }
    
    private func requestQR() {
        NetworkManager.shared.getMyQR(values: KeychainManager.phoneNumber() ?? "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let commonData):
                if commonData.errorCode == .SUCCESSFUL {
                    self.myQRData = commonData.data.convertToPersonalQR()
                    DataManager.shared.saveMyQR(qr: self.myQRData)
                    self.getMyQRSuccess()
                } else {
                    self.fetchDataFailure(commonData.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    private func getStableTokenCustomerMobile() {
        NetworkManager.shared.getStableTokenMobile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableToken):
                if stableToken.errorCode == .SUCCESSFUL {
                    self.stableToken = stableToken.data
                    self.getStableMobileInfSuccess()
                } else {
                    self.fetchDataFailure(stableToken.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenDefault() {
        NetworkManager.shared.getStableToken { result in
            switch result {
            case .success(let stableToken):
                if stableToken.errorCode == .SUCCESSFUL {
                    self.stableTokenDefault = stableToken.data
                    self.getStableMobileDefaultSuccess()
                } else {
                    self.fetchDataFailure(stableToken.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
