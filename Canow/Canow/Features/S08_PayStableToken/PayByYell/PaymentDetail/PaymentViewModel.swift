//
//  PaymentViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 1/6/22.
//

import Foundation

class PaymentViewModel: NSObject {
    
    // MARK: - Properties
    var eCouponInfo: EcouponInfo?
    var fetchDataSuccess: (StableTokenCustomerInfo) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
    var getECouponDetailSuccess: () -> Void = { }
    
    var stableToken: StableTokenMobileInfo?
    var getStableMobileInfSuccess: () -> Void = { }
}

// MARK: - Methods
extension PaymentViewModel {
    
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
    
    func getEcouponDetail(eCouponId: String) {
        NetworkManager.shared.getEcouponDetail(eCouponId: eCouponId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let eCouponDetail):
                if eCouponDetail.errorCode == .SUCCESSFUL {
                    self.eCouponInfo = eCouponDetail.data
                    self.getECouponDetailSuccess()
                } else {
                    self.fetchDataFailure(eCouponDetail.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenCustomerMobile() {
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
}
