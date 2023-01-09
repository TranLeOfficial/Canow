//
//  HomePageViewModel.swift
//  Canow
//
//  Created by PhucNT34 on 1/11/22.
//

import Foundation

class HomePageViewModel: NSObject {
    
    // MARK: - Properties
    var fetchDataFailure: (String) -> Void = { _ in }
    var fetchTeamSelected: (TeamSelectedInfo) -> Void = { _ in }
    var fetchFantokenBalanceInfo: (FantokenBalanceInfo?) -> Void = { _ in }
}

// MARK: - Methods
extension HomePageViewModel {
    
    func fetchData(partnerId: Int) {
        self.getTeamInfoSelected(partnerId: partnerId)
    }
    
    private func getTeamInfoSelected(partnerId: Int) {
        NetworkManager.shared.getPartnerInfomationSelected(partnerId: partnerId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let teamInfo):
                if teamInfo.errorCode == .SUCCESSFUL {
                    self.fetchTeamSelected(teamInfo.data)
                    DataManager.shared.saveMerchantInfo(teamInfo.data)
                } else {
                    self.fetchDataFailure(teamInfo.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getCustomerBalance(tokenType: String) {
        let username = KeychainManager.phoneNumber() ?? ""
        NetworkManager.shared.getCustomerBalance(username: username,
                                          tokenType: tokenType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customerBalance):
                if customerBalance.errorCode == .SUCCESSFUL {
                    self.fetchFantokenBalanceInfo(customerBalance.data.FantokenValue)
                } else {
                    self.fetchDataFailure(customerBalance.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenCustomerMobile() {
        NetworkManager.shared.getStableTokenMobile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableToken):
                if stableToken.errorCode == .SUCCESSFUL {
                    DataManager.shared.saveStableTokenCustomer(stableToken: stableToken.data)
                } else {
                    self.fetchDataFailure(stableToken.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
