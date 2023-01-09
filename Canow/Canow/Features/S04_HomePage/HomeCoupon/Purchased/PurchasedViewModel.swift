//
//  PurchasedViewModel.swift
//  Canow
//
//  Created by PhucNT34 on 1/14/22.
//

import Foundation

class PurchasedViewModel: NSObject {
    
    // MARK: - Properties
    var purchasedData = [PurchasedInfo]()
    
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension PurchasedViewModel {
    
    func getListCouponPurchased(partnerId: Int) {
        NetworkManager.shared.getListCouponPurchased(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coupon):
                if coupon.errorCode == .SUCCESSFUL {
                    if let data = coupon.data {
                        self.purchasedData = data
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
    
}
