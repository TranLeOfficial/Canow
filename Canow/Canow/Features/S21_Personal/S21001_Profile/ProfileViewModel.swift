//
//  ProfileViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation
import UIKit

class ProfileViewModel: NSObject {
    
    // MARK: - Properties
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    
    var addressList = [AddressInfo]()
    var teamList = [TeamInfo]()
    var occupationList = [OccupationInfo]()
    var sportList = [SportInfo]()
    
    var customerInfo: CustomerInfo?
    
    var updateProfileSuccess: () -> Void = { }
    var updateProfileFailure: (String) -> Void = { _ in }
    
    var updateAvatarSuccess: (String) -> Void = { _ in }
    var updateAvatarFailure: (String) -> Void = { _ in }
    
    var getAddressSuccess: () -> Void = { }
    var getOccupationSuccess: () -> Void = { }
    var fetchCustomerInfoSuccess: () -> Void = { }
    
    private var dispatchGroup: DispatchGroup?
    
}

// MARK: - Methods
extension ProfileViewModel {
    
    func fetchData() {
        CommonManager.showLoading()
        
        self.dispatchGroup = DispatchGroup()
        
        self.dispatchGroup?.enter()
        self.getCustomerInfo()
        
        self.dispatchGroup?.enter()
        self.getAddress()
        
        self.dispatchGroup?.enter()
        self.getOccupation()
        
        self.dispatchGroup?.notify(queue: .main) {
            CommonManager.hideLoading()
            self.dispatchGroup = nil
        }
    }
    
    func getCustomerInfo() {
        NetworkManager.shared.getInfoCustomer {  [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.customerInfo = customer.data
                    DataManager.shared.saveCustomerInfo(customer.data)
                    self.fetchCustomerInfoSuccess()
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
            self.dispatchGroup?.leave()
        }
    }
    
    private func getAddress() {
        NetworkManager.shared.getAddress { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userAddress):
                if userAddress.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(userAddress.errorCode.message)
                } else {
                    self.addressList = userAddress.address
                    self.getAddressSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
            self.dispatchGroup?.leave()
        }
    }
    
    private func getOccupation() {
        NetworkManager.shared.getOccupation { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let occupation):
                if occupation.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(occupation.errorCode.message)
                } else {
                    self.occupationList = occupation.occupation
                    self.getOccupationSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
            self.dispatchGroup?.leave()
        }
    }
    
    func saveUpdateProfile(name: String,
                           gender: String,
                           birthday: String,
                           occupationId: Int,
                           addressId: Int,
                           avatar: String) {
        CommonManager.showLoading()
        NetworkManager.shared.saveUpdateProfile(name: name,
                                                gender: gender,
                                                birthday: birthday,
                                                occupationId: occupationId,
                                                addressId: addressId,
                                                avatar: avatar) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updateProfile):
                if updateProfile.errorCode == .SUCCESSFUL {
                    self.getCustomerInfo()
                    self.updateProfileSuccess()
                } else {
                    self.updateProfileFailure(updateProfile.errorCode.message)
                }
                
            case .failure(let error):
                self.updateProfileFailure(error.message)
            }
        }
    }
    
    func uploadProfileAvatar(image: UIImage,
                             fileName: String) {
        CommonManager.showLoading()
        NetworkManager.shared.uploadAvatar(image: image, fileName: fileName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let commonData):
                self.updateAvatarSuccess(commonData.data)
            case .failure(let err):
                self.updateAvatarFailure(err.message)
            }
        }
        
    }
    
    func checkApiToken() -> Bool {
        return KeychainManager.apiIdToken() != nil
    }
    
}
