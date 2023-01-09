//
//  HomeLandingPageViewModel.swift
//  Canow
//
//  Created by NhanTT13 on 2/7/22.
//

import Foundation

class HomeLandingPageViewModel: NSObject {
    // MARK: - Properties
    var news = [NewsInfo]()
    var getNewsListSuccess: () -> Void = { }
    var getNewListFailure: (String) -> Void = { _ in }
    var stableTokenDefault: StableTokenInfo?
    var fetchDataFailure: (String) -> Void = { _ in }

}

// MARK: - Methods
extension HomeLandingPageViewModel {
    func getNewsListWhenDontLogin() {
        NetworkManager.shared.getNewsList(pageIndex: 0,
                                   pageSize: 5,
                                   isLogin: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                if news.errorCode == .SUCCESSFUL {
                    guard let data = news.data else {
                        return
                    }
                    self.news = data
                    self.getNewsListSuccess()
                } else {
                    self.getNewListFailure(news.errorCode.message)
                }
            case .failure(let error):
                print(error)
                self.getNewListFailure(error.message)
            }
        }
    }
    
    func getStableTokenDefault() {
        NetworkManager.shared.getStableToken { result in
            switch result {
            case .success(let stableToken):
                if stableToken.errorCode == .SUCCESSFUL {
                    self.stableTokenDefault = stableToken.data
                    DataManager.shared.saveStableTokenDafault(stableToken: stableToken.data)
                } else {
                    self.fetchDataFailure(stableToken.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
}
