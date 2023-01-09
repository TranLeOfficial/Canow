//
//  HomeCrowdfundingViewModel.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import Foundation

class HomeCrowdfundingViewModel: NSObject {
    
    // MARK: - Properties
    var crowdfundingData = [CrowdfundingInfo]()
    
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension HomeCrowdfundingViewModel {
    
    func getCrowdfunding(partnerId: Int) {
        NetworkManager.shared.getCrowdfunding(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let crowdfunding):
                if crowdfunding.errorCode == .SUCCESSFUL {
                    if let data = crowdfunding.data {
                        self.crowdfundingData = data
                    }
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(crowdfunding.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
