//
//  NewsListViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 15/11/2021.
//

import Foundation

class NewsListViewModel: NSObject {
    
    // MARK: - Properties
    var news = [NewsInfo]()
    var getNewsListSuccess: () -> Void = { }
    var getNewListFailure: (String) -> Void = { _ in }

    // MARK: - Methods
    func getNewsListWhenDontLogin() {
        NetworkManager.shared.getNewsList(pageIndex: 0,
                                          pageSize: 1000,
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
}
