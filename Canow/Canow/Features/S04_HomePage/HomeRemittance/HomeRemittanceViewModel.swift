//
//  HomeRemittanceViewModel.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import Foundation

class HomeRemittanceViewModel: NSObject {
    
    // MARK: - Properties
    var remittanceData = [RemittanceInfo]()
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension HomeRemittanceViewModel {
    
    func getRemittance(partnerId: Int) {
        NetworkManager.shared.getRemittance(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let remittance):
                if remittance.errorCode == .SUCCESSFUL {
                    if let data = remittance.data {
                        self.remittanceData = data
                    }
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(remittance.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
