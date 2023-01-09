//
//  UpdateProfileViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 21/10/2021.
//

import Foundation
import UIKit

class UpdateProfileViewModel: NSObject {
    
    // MARK: - Properties
    var addressList = [AddressInfo]()
    var occupationList = [OccupationInfo]()
    var teamList = [TeamInfo]()
    
    var updateProfileSuccess: () -> Void = { }
    var uploadAvatarSuccess: (String) -> Void = { _ in }
    var getAddressSuccess: () -> Void = { }
    var getOccupationSuccess: () -> Void = { }
    var getTeamListSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension UpdateProfileViewModel {
    
    func saveUpdateProfile(idToken: String,
                           name: String,
                           gender: String,
                           birthday: String,
                           occupationId: Int,
                           addressId: Int,
                           teamId: Int,
                           sportId: Int,
                           avatar: String) {
        CommonManager.showLoading()
        NetworkManager.shared.saveProfileWhenSignUp(idToken: idToken,
                                                    name: name,
                                                    gender: gender,
                                                    birthday: birthday,
                                                    occupationId: occupationId,
                                                    addressId: addressId,
                                                    teamId: teamId,
                                                    sportId: sportId,
                                                    avatar: avatar) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updateProfile):
                if updateProfile.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(updateProfile.errorCode.message)
                } else {
                    self.updateProfileSuccess()
                }
                
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func uploadAvatar(idToken: String, image: UIImage, fileName: String) {
        CommonManager.showLoading()
        NetworkManager.shared.uploadAvatarRegister(idToken: idToken, image: image, fileName: fileName) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let avatar):
                if avatar.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(avatar.errorCode.message)
                } else {
                    self.uploadAvatarSuccess(avatar.data)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getAddress() {
        NetworkManager.shared.getAddress(completion: { [weak self] result in
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
        })
    }
    
    func getTeam() {
        NetworkManager.shared.getTeamList(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let team):
                if team.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(team.errorCode.message)
                } else {
                    self.teamList = team.data
                    self.getTeamListSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        })
    }
    
    func getOccupation() {
        NetworkManager.shared.getOccupation(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let occupationList):
                if occupationList.errorCode != .SUCCESSFUL {
                    self.fetchDataFailure(occupationList.errorCode.message)
                } else {
                    self.occupationList = occupationList.occupation
                    self.getOccupationSuccess()
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        })
    }
    
}
