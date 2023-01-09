//
//  FavoriteTeamViewModel.swift
//  Canow
//
//  Created by hieplh2 on 10/12/2021.
//

import Foundation

class FavoriteTeamViewModel: NSObject {
    
    // MARK: - Properties
    var sports = [SportInfo]()
    var partners = [PartnerSportInfo]()
    
    var updateTeamSuccess: () -> Void = { }
    var fetchTeamSelected: () -> Void = { }
    var getSportListSuccess: () -> Void = { }
    var getPartnerListSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension FavoriteTeamViewModel {
    
    func getSport() {
        CommonManager.showLoading()
        NetworkManager.shared.getSport { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let sportList):
                if sportList.errorCode == .SUCCESSFUL {
                    self.sports = sportList.sport
                    self.getSportListSuccess()
                } else {
                    self.fetchDataFailure(sportList.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getPartnerBySportId(sportId: Int) {
        CommonManager.showLoading()
        NetworkManager.shared.getPartnerBySportId(sportId: sportId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let partnerList):
                if partnerList.errorCode == .SUCCESSFUL {
                    if let partners = partnerList.data {
                        self.partners = partners
                    }
                    self.getPartnerListSuccess()
                } else {
                    self.fetchDataFailure(partnerList.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func updateTeam(sportId: Int, teamId: Int) {
        CommonManager.showLoading()
        NetworkManager.shared.updateTeam(sportId: sportId, teamId: teamId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(_):
                NetworkManager.shared.getInfoCustomer { result in
                    switch result {
                    case .success(let customer):
                        if customer.errorCode == .SUCCESSFUL {
                            DataManager.shared.saveCustomerInfo(customer.data)
                            self.updateTeamSuccess()
                        } else {
                            self.fetchDataFailure(customer.errorCode.message)
                        }
                    case .failure(let error):
                        print(error)
                        self.fetchDataFailure(error.message)
                    }
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getTeamInfoSelected(partnerId: Int) {
        NetworkManager.shared.getPartnerInfomationSelected(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let teamInfo):
                if teamInfo.errorCode == .SUCCESSFUL {
                    self.fetchTeamSelected()
                    DataManager.shared.saveMerchantInfo(teamInfo.data)
                } else {
                    self.fetchDataFailure(teamInfo.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
