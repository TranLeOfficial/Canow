//
//  LanguageSettingViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 13/10/2021.
//

import Foundation

class LanguageSettingViewModel: NSObject {
   
    // MARK: - Properties
    var changeLanguageSuccess: () -> Void = { }
    var changeLanguageFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension LanguageSettingViewModel {
    
    func changeLanguage(language: String) {
        NetworkManager.shared.updateLanguage(language: language) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let languageResult):
                if languageResult.errorCode == .SUCCESSFUL {
                    self.changeLanguageSuccess()
                } else {
                    self.changeLanguageFailure(languageResult.errorCode.message)
                }
            case .failure(let error):
                self.changeLanguageFailure(error.message)
            }
        }
    }
    
}
