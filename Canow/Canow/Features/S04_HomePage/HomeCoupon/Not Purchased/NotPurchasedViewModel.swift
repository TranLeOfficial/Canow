//
//  NotPurchasedViewModel.swift
//  Canow
//
//  Created by PhucNT34 on 1/14/22.
//

import Foundation

class NotPurchasedViewModel: NSObject {
    
    // MARK: - Properties
    var notPurchasedData = [CouponInfo]()
    
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var fetchFantokenBalanceInfo: (FantokenBalanceInfo?) -> Void = { _ in }
}

// MARK: - Methods
extension NotPurchasedViewModel {
    
    func getListCouponAvailable(partnerId: Int) {
        NetworkManager.shared.getListCouponAvailable(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coupon):
                if coupon.errorCode == .SUCCESSFUL {
                    if let data = coupon.data {
                        self.notPurchasedData = data
                    }
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(coupon.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getCustomerBalance(tokenType: String) {
        let username = KeychainManager.phoneNumber() ?? ""
        NetworkManager.shared.getCustomerBalance(username: username,
                                          tokenType: tokenType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customerBalance):
                if customerBalance.errorCode == .SUCCESSFUL {
                    self.fetchFantokenBalanceInfo(customerBalance.data.FantokenValue)
                } else {
                    self.fetchDataFailure(customerBalance.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
