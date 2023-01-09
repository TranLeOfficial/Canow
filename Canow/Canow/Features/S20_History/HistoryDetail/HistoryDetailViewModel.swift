//
//  HistoryDetailViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 11/8/21.
//

import Foundation

class HistoryDetailViewModel: NSObject {
    
    // MARK: - Properties
    var transactionDetail: TransactionDetail?
    var receiverInfo: CustomerInfo?
    var stableToken: StableTokenMobileInfo?
    var fetchReceiverInfoSuccess: () -> Void = { }
    var fetchStableTokenSuccess: () -> Void = { }
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension HistoryDetailViewModel {
    
    func getTransactionDetail(transactionId: String) {
        NetworkManager.shared.getTransactionId(transactionId: transactionId) { result in
            switch result {
            case .success(let transactionDetail):
                if transactionDetail.errorCode == .SUCCESSFUL {
                    self.transactionDetail = transactionDetail.data
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(transactionDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getReceiverInfo(phoneNumber: String) {
        NetworkManager.shared.getReceiverInfo(phoneNumber: phoneNumber) { result in
            switch result {
            case .success(let receiver):
                if receiver.errorCode == .SUCCESSFUL {
                    self.receiverInfo = receiver.data
                    self.fetchReceiverInfoSuccess()
                } else {
                    self.fetchDataFailure(receiver.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableToken() {
        NetworkManager.shared.getStableTokenMobile { result in
            switch result {
            case .success(let stableToken):
                if stableToken.errorCode == .SUCCESSFUL {
                    self.stableToken = stableToken.data
                    self.fetchStableTokenSuccess()
                } else {
                    self.fetchDataFailure(stableToken.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
