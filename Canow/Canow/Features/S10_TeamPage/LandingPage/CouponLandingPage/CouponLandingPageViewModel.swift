//
//  CouponLandingPageViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 2/7/22.
//

import Foundation

class CouponLandingPageViewModel: NSObject {
    
    // MARK: - Properties
    var notPurchasedData = [CouponInfo]()
    
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension CouponLandingPageViewModel {
    
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
    
}
