//
//  TopupGiftCardViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation

class TopupGiftCardViewModel: NSObject {
    
    // MARK: - Properties
    var fetchDataSuccess: (String) -> Void = { _ in }
    var fetchDataFailure: (String) -> Void = { _ in }
    var fetchGiftCardInfoSuccess: (GiftCardInfo) -> Void = { _ in }

}

// MARK: - Methods
extension TopupGiftCardViewModel {
    
    func topupGiftCard(giftcardId: String) {
        CommonManager.showLoading()
        NetworkManager.shared.topUpGiftCard(giftcardId: giftcardId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topupGiftCard):
                if topupGiftCard.errorCode == .SUCCESSFUL {
                    self.fetchDataSuccess(topupGiftCard.data.stringValue)
                } else {
                    self.fetchDataFailure(topupGiftCard.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
    func getGiftCardInfo(giftcardId: String) {
        NetworkManager.shared.getGiftCard(giftCardId: giftcardId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let topupGiftCard):
                if topupGiftCard.errorCode == .SUCCESSFUL {
                    guard let giftCardInfo = topupGiftCard.data.GiftCardValue else { return }
                    self.fetchGiftCardInfoSuccess(giftCardInfo)
                } else {
                    self.fetchDataFailure(topupGiftCard.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }

}
