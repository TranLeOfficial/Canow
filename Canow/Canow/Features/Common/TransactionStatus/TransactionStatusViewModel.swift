//
//  TransactionStatusViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation

class TransactionStatusViewModel: NSObject {
    
    // MARK: - Properties
    var giftcard: GiftCardInfo?
    var transactionStatus: TransactionStatusRedeemInfo?
    var fetchGiftCardSuccess: () -> Void = { }
    var transactionSuccess:(TransactionResult) -> Void = { _ in }
    var fetchTransactionStatusSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var getPartnerInfSuccess: () -> Void = { }
    var getPartnerInfFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension TransactionStatusViewModel {
    
    func getTransactionStatus(transactionId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            NetworkManager.shared.getTransactionStatus(transactionId: transactionId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let transactionStatus):
                    if transactionStatus.errorCode == .SUCCESSFUL {
                        self.transactionStatus = transactionStatus.data
                        self.fetchTransactionStatusSuccess()
                    } else {
                        self.fetchDataFailure(transactionStatus.errorCode.message)
                    }
                case .failure(let error):
                    self.fetchDataFailure(error.message)
                }
            }
        }
    }
    
    func getTeamInfoSelected(partnerId: Int) {
        NetworkManager.shared.getPartnerInfomationSelected(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let teamInfo):
                if teamInfo.errorCode == .SUCCESSFUL {
                    self.getPartnerInfSuccess()
                    DataManager.shared.saveMerchantInfo(teamInfo.data)
                } else {
                    self.getPartnerInfFailure(teamInfo.errorCode.message)
                }
            case .failure(let error):
                self.getPartnerInfFailure(error.message)
            }
        }
    }
    
}
