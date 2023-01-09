//
//  RemittanceCampaignViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import Foundation

class RemittanceCampaignViewModel: NSObject {
    
    // MARK: - Properties
    var remittanceItemList = [RemittanceItemInfo]()
    var remittanceCampaign: RemittanceCampaignInfo?
    
    var fetchRemittanceItemSuccess: () -> Void = { }
    var fetchRemittanceItemWhenDonateSuccess: ([RemittanceItemInfo]) -> Void = { _ in }
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    var fetchFantokenBalanceInfo: (FantokenBalanceInfo?) -> Void = { _ in }
    var fetchTeamSelected: (TeamSelectedInfo) -> Void = { _ in }
    
    var checkWhenDonateSuccess: () -> Void = { }
    var checkWhenDonateFailure: (String) -> Void = { _ in }
    var getCustomerBalanceFailure: (String) -> Void = { _ in }
}

extension RemittanceCampaignViewModel {

    func checkWhenDonate(campaignId: Int, campaignItemId: Int, price: Int) {
        NetworkManager.shared.checkWhenDonate(campaignId: campaignId,
                                              campaignItemId: campaignItemId,
                                              price: price) { result in
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.checkWhenDonateSuccess()
                } else {
                    self.checkWhenDonateFailure(transactionResult.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getRemittanceCampaign(remittanceId: Int) {
        NetworkManager.shared.getRemittanceCampaign(remittanceId: remittanceId) { result in
            switch result {
            case .success(let remittanceCampaign):
                if remittanceCampaign.errorCode == .SUCCESSFUL {
                    self.remittanceCampaign = remittanceCampaign.data
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(remittanceCampaign.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getCampaignItem() {
        NetworkManager.shared.getCampaignItem { result in
            switch result {
            case .success(let remittanceItemList):
                if remittanceItemList.errorCode == .SUCCESSFUL {
                    self.remittanceItemList = remittanceItemList.data
                    self.fetchRemittanceItemSuccess()
                } else {
                    self.fetchDataFailure(remittanceItemList.errorCode.message)
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
                    self.fetchTeamSelected(teamInfo.data)
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
                    self.getCustomerBalanceFailure(customerBalance.errorCode.message)
                }
            case .failure(let error):
                self.getCustomerBalanceFailure(error.message)
            }
        }
    }
    
}
