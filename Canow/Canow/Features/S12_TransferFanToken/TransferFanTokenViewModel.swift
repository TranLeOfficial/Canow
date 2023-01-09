//
//  TransferFanTokenViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 11/22/21.
//

import Foundation

class TransferFanTokenViewModel: NSObject {
    
    // MARK: - Properties
    var receiverTransferInfo = [ReceiverTransferInfo]()
    var fetchDataFailure: (String) -> Void = { _ in }
    var fetchDataReceiver: () -> Void = { }
    
}

// MARK: - Methods
extension TransferFanTokenViewModel {
    
    func getListReceiver(phoneNumber: String) {
        CommonManager.showLoading()
        NetworkManager.shared.getListReceiver(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let receiverTransfer):
                if receiverTransfer.errorCode == .SUCCESSFUL {
                    self.receiverTransferInfo = receiverTransfer.data
                    self.fetchDataReceiver()
                } else {
                    self.fetchDataFailure(receiverTransfer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
