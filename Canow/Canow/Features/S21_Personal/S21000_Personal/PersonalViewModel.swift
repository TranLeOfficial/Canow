//
//  PersonalViewModel.swift
//  Canow
//
//  Created by NhanTT13 on 11/9/21.
//

import Foundation
import AVFoundation
import UIKit
import Localize

struct PersonalData {
    let title: String
    let icon: String
}

class PersonalViewModel: NSObject {
    
    // MARK: - Properties
    var personalData: [[PersonalData]] = [[]]
    var customerInfo: CustomerInfo?
    var fetchCustomerInfoSuccess: (CustomerInfo) -> Void = { _ in }
    var uploadAvatarSuccess: (String) -> Void = { _ in }
    var updateAvatarSuccess: () -> Void = {}
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension PersonalViewModel {
    
    func fetchData() {
        self.personalData = [
            [
                PersonalData(title: StringConstants.s07TransactionHistory.localized, icon: "ic_personal_transaction")
            ],
            [
                PersonalData(title: StringConstants.s07FavoriteTeam.localized, icon: "ic_personal_favorite")
            ],
            [
                PersonalData(title: StringConstants.s07TermCondition.localized, icon: "ic_personal_terms"),
                PersonalData(title: StringConstants.s07EcommerceLaw.localized, icon: "ic_personal_ecommerce")
            ],
            [
                PersonalData(title: StringConstants.s07LanguageSetting.localized, icon: "ic_personal_language"),
                PersonalData(title: StringConstants.s07Help.localized, icon: "ic_personal_help")
            ],
            [
                PersonalData(title: StringConstants.s07LogOut.localized, icon: "ic_personal_logout")
            ]
        ]
        self.getInfoCustomer()
    }
    
    private func getInfoCustomer() {
        guard let customerInfo = DataManager.shared.getCustomerInfo() else { return }
        self.customerInfo = customerInfo
        self.fetchCustomerInfoSuccess(customerInfo)
    }
    
    func updateAvatar(avatar: String) {
        NetworkManager.shared.updateAvatar(avatar: avatar) { result in
            switch result {
            case .success(_):
                self.requestInfoCustomer()
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func uploadAvatar(image: UIImage, fileName: String) {
        CommonManager.showLoading()
        NetworkManager.shared.uploadAvatar(image: image, fileName: fileName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let commonData):
                self.uploadAvatarSuccess(commonData.data)
            case .failure(let err):
                self.fetchDataFailure(err.message)
            }
        }
    }
    
    func checkApiToken() -> Bool {
        return KeychainManager.apiIdToken() != nil
    }
    
    func logout() {
        CommonManager.clearData()
        self.customerInfo = nil
        Localize.update(language: UserDefaultManager.language ?? Localize.currentLanguage)
    }
    
    private func requestInfoCustomer() {
        NetworkManager.shared.getInfoCustomer { result in
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.customerInfo = customer.data
                    DataManager.shared.saveCustomerInfo(customer.data)
                    self.updateAvatarSuccess()
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
