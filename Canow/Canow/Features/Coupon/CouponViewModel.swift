//
//  CouponViewModel.swift
//  Canow
//
//  Created by hieplh2 on 04/01/2022.
//

import Foundation

class CouponViewModel: NSObject {
    
    var couponDetail: CouponDetailInfo?
    var fantokenInfo: FantokenBalanceInfo?
    var getCouponDetailSuccess: () -> Void = {}
    var fetchDataRedeemFailure: (String) -> Void = { _ in }
    var redeemFailure: (String) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
    var fetchStableTokenSuccess: (StableTokenCustomerInfo) -> Void = { _ in }
    var validateSuccess: (String) -> Void = { _ in }
    var removeCouponSuccess: () -> Void = {}
    var fetchFantokenBalanceInfo: () -> Void = { }
    
    var stableToken: StableTokenMobileInfo?
    var getStableMobileInfSuccess: () -> Void = { }
    var fetchDataUserMobileSuccess: (StableTokenCustomerInfo) -> Void = { _ in }
    var fetchFantokenBalanceInfoFailure: (String) -> Void = { _ in }
    var fetchTeamSelected: () -> Void = { }
}

extension CouponViewModel {
    
    func getCouponDetail(eCouponId: String) {
        CommonManager.showLoading()
        NetworkManager.shared.getCouponDetail(eCouponId: eCouponId) { result in
            switch result {
            case .success(let couponDetail):
                if couponDetail.errorCode == .SUCCESSFUL {
                    self.couponDetail = couponDetail.data
                    self.getCouponDetailSuccess()
                } else {
                    self.fetchDataFailure(couponDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenCustomer() {
        guard let phoneNumber = KeychainManager.phoneNumber() else {
            return
        }
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableTokenCustomer):
                if stableTokenCustomer.errorCode == .SUCCESSFUL {
                    self.fetchStableTokenSuccess(stableTokenCustomer.data)
                } else {
                    self.fetchDataFailure(stableTokenCustomer.errorCode.message)
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
                    self.fantokenInfo = customerBalance.data.FantokenValue
                    self.fetchFantokenBalanceInfo()
                } else {
                    self.fetchFantokenBalanceInfoFailure(customerBalance.errorCode.message)
                }
            case .failure(let error):
                self.fetchFantokenBalanceInfoFailure(error.message)
            }
        }
    }
    
    func checkUseCoupon(partnerId: Int, eCouponId: String) {
        CommonManager.showLoading()
        NetworkManager.shared.checkUseCoupon(partnerId: partnerId, eCouponId: eCouponId) { result in
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.validateSuccess(transactionResult.data.stringValue)
                } else {
                    self.fetchDataFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func checkRedeemCoupon(eCouponId: String) {
        CommonManager.showLoading()
        NetworkManager.shared.checkRedeemCoupon(couponId: eCouponId) { result in
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.validateSuccess(transactionResult.data.stringValue)
                } else {
                    self.redeemFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func removeCoupon(eCouponId: String) {
        CommonManager.showLoading()
        NetworkManager.shared.removeCoupon(eCouponId: eCouponId) { result in
            switch result {
            case .success(let deleteResult):
                if deleteResult.errorCode == .SUCCESSFUL {
                    self.removeCouponSuccess()
                } else {
                    self.fetchDataRedeemFailure(deleteResult.errorCode.message)
                }
            case .failure(let error):
                self.redeemFailure(error.message)
            }
        }
    }
    
    func getTeamInfoSelected(partnerId: Int) {
        NetworkManager.shared.getPartnerInfomationSelected(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let teamInfo):
                if teamInfo.errorCode == .SUCCESSFUL {
                    self.fetchTeamSelected()
                    DataManager.shared.saveMerchantInfo(teamInfo.data)
                } else {
                    self.fetchDataFailure(teamInfo.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }

}
