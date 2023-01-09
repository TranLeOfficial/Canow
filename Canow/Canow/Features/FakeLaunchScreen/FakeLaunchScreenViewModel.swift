//
//  FakeLaunchScreenViewModel.swift
//  Canow
//
//  Created by hieplh2 on 28/12/2021.
//

import Foundation

class FakeLaunchScreenViewModel: NSObject {
    
    var fetchDataSuccess: () -> Void = {}
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension FakeLaunchScreenViewModel {
    
    func getCustomerInfo() {
        NetworkManager.shared.getInfoCustomer { result in
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    DataManager.shared.saveCustomerInfo(customer.data)
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
                print(error)
            }
        }
    }
    
}
