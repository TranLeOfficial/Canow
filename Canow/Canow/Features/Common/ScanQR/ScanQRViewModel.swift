//
//  ScanQRViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 1/25/22.
//

import Foundation

class ScanQRViewModel: NSObject {
    
    // MARK: - Properties
    var partnerInfo: TeamSelectedInfo?
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var universalLinkData: UniversalLinkData?
    var fetchUniversalLinkSuccess: () -> Void = { }
}

// MARK: - Methods
extension ScanQRViewModel {
    
    func getPartnerInfomationSelected(partnerId: Int) {
        NetworkManager.shared.getPartnerInfomationSelected(partnerId: partnerId) { result in
            switch result {
            case .success(let transactionDetail):
                if transactionDetail.errorCode == .SUCCESSFUL {
                    self.partnerInfo = transactionDetail.data
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(transactionDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getUniversalLinkData(deeplink: String) {
        guard let deepLink = deeplink.urlEncoded else { return }
        NetworkManager.shared.getUniversalLinkData(deeplink: deepLink) { result in
            switch result {
            case .success(let transactionDetail):
                if transactionDetail.errorCode == .SUCCESSFUL {
                    self.universalLinkData = transactionDetail.data.universalLinkData
                    self.fetchUniversalLinkSuccess()
                } else {
                    self.fetchDataFailure(transactionDetail.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
}
