//
//  InputAmountTransactionViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 11/26/21.
//

import Foundation

class InputAmountTransactionViewModel: NSObject {
    
    // MARK: - Properties
    var customerInfo: StableTokenCustomerInfo?
    var teamSelected : TeamSelectedInfo?
    var fetchDataExchangeCustomerSuccess: (StableTokenCustomerInfo) -> Void = { _ in }
    
    var topUpFailure: (String) -> Void = { _ in }
    
    var fetchDataSuccess: (TopupCardInfo) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
    
    var transactionSuccess: (TransactionResult) -> Void = { _ in }
    var transactionFailure: ((String, String)) -> Void = { _ in }
    var stableTokenCusomerInfo: StableTokenCustomerInfo?
    var fetchStableTokenCustomerSuccess: () -> Void = {}

    var getPartnerInfSuccess: () -> Void = { }
    var getPartnerInfFailure: (String) -> Void = { _ in }
    
    var fetchCustomerInfoSuccess: (CustomerInfo) -> Void = { _ in }
    
    var inputAmountPayBySTSuccess: (String) -> Void = { _ in }
    var inputAmountPayBySTFailure: (String) -> Void = { _ in }
    
    // MARK: - Properties
    var fetchDataSuccessCustomer: (StableTokenCustomerInfo) -> Void = { _ in }
    var fetchDataFailureCustomer: (String) -> Void = { _ in }
}

// MARK: - Methods
extension InputAmountTransactionViewModel {
    
    func fetchData() {
        self.getCustomerInfo()
    }
 
    func topupCard(amount: Int) {
//        CommonManager.showLoading()
        NetworkManager.shared.topUpCard(amount: amount) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topupCard):
                if topupCard.errorCode == .SUCCESSFUL {
                    self.fetchDataSuccess(topupCard.data)
                } else {
                    self.topUpFailure(topupCard.errorCode.message)
                }
            case .failure(let error):
                self.topUpFailure(error.message)
            }
        }
    }
    
    func recommendAmount(amount: Int, transactionType: TransactionType) -> [String] {
        var outputAmount: [String] = []
        switch transactionType {
        case .topUp:
            var rangeArray = [amount, amount * 10, amount * 100, amount * 1000]
            if amount >= 100 {
                let array = Array("\(amount)")
                let const = Int(String(array[0...1])) ?? 0
                rangeArray = [const, const * 10, const * 100, const * 1000]
            }
            for (index, item) in rangeArray.enumerated() {
                if index == rangeArray.count - 1 {
                    if item > 50000 {
                        outputAmount.append("50000")
                    } else {
                        outputAmount.append(String(item))
                    }
                } else {
                    outputAmount.append(String(item))
                }
            }
        default:
            outputAmount = ["\(amount * 10)",
                            "\(amount * 100)",
                            "\(amount * 1000)",
                            "\(amount * 10000)"]
        }
        return outputAmount
    }
    
    func transferStableToken(amount: Int, receiver: String) {
        NetworkManager.shared.transferStableToken(amount: amount, receiver: receiver) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transactionResult):
                if transactionResult.errorCode == .SUCCESSFUL {
                    self.transactionSuccess(transactionResult)
                } else {
                    self.transactionFailure((transactionResult.errorCode.message, transactionResult.data.stringValue))
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
                    self.teamSelected = teamInfo.data
                    self.getPartnerInfSuccess()
                } else {
                    self.getPartnerInfFailure(teamInfo.errorCode.message)
                }
            case .failure(let error):
                self.getPartnerInfFailure(error.message)
            }
        }
    }

    private func getCustomerInfo() {
        guard let customerInfo = DataManager.shared.getCustomerInfo() else { return }
        let phoneNumber = KeychainManager.phoneNumber() ?? ""
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let customer):
                if customer.errorCode == .SUCCESSFUL {
                    self.customerInfo = customer.data
                    self.fetchCustomerInfoSuccess(customerInfo)
                } else {
                    self.fetchDataFailure(customer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenCustomer() {
        guard let phoneNumber = KeychainManager.phoneNumber() else {
            return
        }
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableTokenCustomer):
                if stableTokenCustomer.errorCode == .SUCCESSFUL {
                    self.stableTokenCusomerInfo = stableTokenCustomer.data
                    self.fetchDataSuccessCustomer(stableTokenCustomer.data)
                } else {
                    self.fetchDataFailureCustomer(stableTokenCustomer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getStableTokenCustomerExchange() {
        guard let phoneNumber = KeychainManager.phoneNumber() else {
            return
        }
        NetworkManager.shared.getStableTokenCustomer(phoneNumber: phoneNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stableTokenCustomer):
                if stableTokenCustomer.errorCode == .SUCCESSFUL {
                    self.fetchDataExchangeCustomerSuccess(stableTokenCustomer.data)
                } else {
                    self.fetchDataFailure(stableTokenCustomer.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
}
