//
//  TransactionConfirmViewModel.swift
//  Canow
//
//  Created by NhiVHY on 1/5/22.
//

import Foundation

class TransactionConfirmViewModel: NSObject {
    
    // MARK: - Properties
    var fetchDataFailure: (String) -> Void = { _ in }
    var transactionSuccess: (TransactionResult) -> Void = { _ in }
    var inputAmountPayBySTSuccess: (String) -> Void = { _ in }
    var payWithCouponSuccess: (String) -> Void = { _ in }
    var redeemSuccess: (String) -> Void = { _ in }
    var redeemCouponSuccess: (String) -> Void = { _ in }
    var donateSuccess: (String) -> Void = { _ in }
    var useCouponsuccess: (String) -> Void = { _ in }
    var useCouponRedEnvelopeSusccess: (String) -> Void = { _ in }
    var useCouponAirdropSuccess: (String) -> Void = { _ in }
    
    var fetchRemittanceItemWhenDonateSuccess: ([RemittanceItemInfo]) -> Void = { _ in }
    
    // Exchange
    var fetchDataExchangeSuccess: (String) -> Void = { _ in }
    var transactionExchangeFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension TransactionConfirmViewModel {
    
    func donateNow(campaignId: Int, campaignItemId: Int) {
        CommonManager.showLoading()
        NetworkManager.shared.donateNow(campaignId: campaignId, campaignItemId: campaignItemId) { result in
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.donateSuccess(transactionResult.data.stringValue)
                } else {
                    self.fetchDataFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func transferStableToken(amount: Int, receiver: String) {
        CommonManager.showLoading()
        NetworkManager.shared.transferStableToken(amount: amount, receiver: receiver) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.transactionSuccess(transactionResult)
                } else {
                    self.fetchDataFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func transferFantoken(amount: Int, receiver: String, tokenType: String) {
        CommonManager.showLoading()
        NetworkManager.shared.transferFanToken(amount: amount, receiver: receiver, tokenType: tokenType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.transactionSuccess(transactionResult)
                } else {
                    self.fetchDataFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func couponUse(partnerId: Int, ecouponId: String) {
        NetworkManager.shared.couponUse(eCouponId: ecouponId,
                                        partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(commonData.errorCode.message)
                } else {
                    self.useCouponsuccess(commonData.data.stringValue)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func payWithCoupon(partnerId: Int, ecouponId: String) {
        NetworkManager.shared.couponUse(eCouponId: ecouponId,
                                        partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(commonData.errorCode.message)
                } else {
                    self.payWithCouponSuccess(commonData.data.stringValue)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
      
    func payByST(partnerId: Int, amount: Int) {
        NetworkManager.shared.payByST(partnerId: partnerId, amount: amount) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(commonData.errorCode.message)
                } else {
                    self.inputAmountPayBySTSuccess(commonData.data.stringValue)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func redeemCourse(couponId: String) {
        NetworkManager.shared.redeemCourse(id: couponId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let rsp):
                if rsp.errorCode == .SUCCESSFUL {
                    self.redeemSuccess(rsp.data.stringValue)
                } else {
                    self.fetchDataFailure(rsp.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func couponRedeem(eCouponId: String) {
        CommonManager.showLoading()
        NetworkManager.shared.couponRedeem(couponId: eCouponId) { result in
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.redeemCouponSuccess(transactionResult.data.stringValue)
                } else {
                    self.fetchDataFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func amountExchange(partnerId: Int,
                        amount: Int) {
        NetworkManager.shared.postExchangeStableToken(partnerId: partnerId,
                                                      amount: amount) { result in
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.fetchDataExchangeSuccess(transactionResult.data.stringValue)
                } else {
                    self.transactionExchangeFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getAndCheckCampaignItem() {
        NetworkManager.shared.getCampaignItem { result in
            switch result {
            case .success(let remittanceItemList):
                if remittanceItemList.errorCode == .SUCCESSFUL {
                    self.fetchRemittanceItemWhenDonateSuccess(remittanceItemList.data)
                } else {
                    self.fetchDataFailure(remittanceItemList.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func couponRedEnvelopeUse(partnerId: Int, ecouponId: String) {
        NetworkManager.shared.couponRedEnvelopeUse(eCouponId: ecouponId,
                                        partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(commonData.errorCode.message)
                } else {
                    self.useCouponRedEnvelopeSusccess(commonData.data.stringValue)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func couponAirdropUse(partnerId: Int, ecouponId: String) {
        NetworkManager.shared.couponAirdropUse(eCouponId: ecouponId,
                                        partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(commonData.errorCode.message)
                } else {
                    self.useCouponAirdropSuccess(commonData.data.stringValue)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
}
