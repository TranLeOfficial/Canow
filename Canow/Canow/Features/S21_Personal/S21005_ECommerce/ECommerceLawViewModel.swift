//
//  ECommerceLawViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 27/10/2021.
//

import Foundation

class ECommerceLawViewModel: NSObject {
    
    // MARK: - Properties
    var ECommerceLawData = String()
    var getECommerceLawSuccess: () -> Void = { }
    var getECommerceLawFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension ECommerceLawViewModel {
    
    func getTermsAndConditions() {
        CommonManager.showLoading()
        NetworkManager.shared.getECommerceLaw(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.getECommerceLawFailure(commonData.errorCode.message)
                } else {
                    self.ECommerceLawData = commonData.data
                    self.getECommerceLawSuccess()
                }
            case .failure(let error):
                self.getECommerceLawFailure(error.message)
            }
        })
    }
    
}
