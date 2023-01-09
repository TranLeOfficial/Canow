//
//  PayCouponUseViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 1/5/22.
//

import Foundation

class PayCouponUseViewModel: NSObject {
    
    // MARK: - Properties
    var listCoupon = [CouponMerchantInfo]()
    var eCouponInfo: EcouponInfo?
    var getListCouponSuccess: () -> Void = { }
    var getECouponDetailSuccess: () -> Void = { }
    var getMerchantInfoSuccess: (TeamSelectedInfo) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension PayCouponUseViewModel {
    
    func getListCouponByMerchantId(merchantId: Int) {
        NetworkManager.shared.getListCouponByMerchantId(merchantId: merchantId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let listMerchant):
                if listMerchant.errorCode == .SUCCESSFUL {
                    self.listCoupon = listMerchant.data
                    self.getListCouponSuccess()
                } else {
                    self.fetchDataFailure(listMerchant.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getMerchantById(merchantId: Int) {
        NetworkManager.shared.getPartnerInfomationSelected(partnerId: merchantId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let merchant):
                if merchant.errorCode == .SUCCESSFUL {
                    self.getMerchantInfoSuccess(merchant.data)
                } else {
                    self.fetchDataFailure(merchant.errorCode.message)
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
    
}
