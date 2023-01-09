//
//  RewardViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 24/02/2022.
//

import Foundation

class RewardViewModel: NSObject {
    
    // MARK: - Properties
    var redEnvelopeCustomerScanDetail: RedEnvelopeCustomerScanDetail?
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var transactionStatus: TransactionStatusRedeemInfo?
    var fetchTransactionStatusSuccess: () -> Void = { }
    
}

// MARK: - Methods
extension RewardViewModel {
    
    func getPartnerInfomationSelected(id: Int) {
        CommonManager.showLoading()
        NetworkManager.shared.redEnvelopeCustomerScan(id: id) { result in
            switch result {
            case .success(let transactionDetail):
                if transactionDetail.errorCode == .SUCCESSFUL {
                    self.redEnvelopeCustomerScanDetail = transactionDetail.data
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(transactionDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
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
    
}
