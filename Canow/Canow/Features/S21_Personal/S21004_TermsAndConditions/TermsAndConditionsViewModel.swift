//
//  TermsAndConditionsViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 26/10/2021.
//

import Foundation
import Alamofire

class TermsAndConditionsViewModel: NSObject {
    // MARK: - Properties
    var termsAndConditionsData = String()
    var getTermsAndConditionsSuccess: () -> Void = { }
    var getTermsAndConditionsFailure: (String) -> Void = { _ in }
}

// MARK: - Methods
extension TermsAndConditionsViewModel {
    
    func getTermsAndConditions() {
        CommonManager.showLoading()
        NetworkManager.shared.getTermsAndConditions(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let commonData):
                if commonData.errorCode != .SUCCESSFUL {
                    self.getTermsAndConditionsFailure(commonData.errorCode.message)
                } else {
                    self.termsAndConditionsData = commonData.data
                    self.getTermsAndConditionsSuccess()
                }
            case .failure(let error):
                self.getTermsAndConditionsFailure(error.message)
            }
        })
    }
    
}
