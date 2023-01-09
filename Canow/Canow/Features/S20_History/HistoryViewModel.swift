//
//  HistoryViewModel.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import Foundation

class HistoryViewModel: NSObject {
    
    // MARK: - Properties
    var listHistory = [HistoryInfo]()
    var fetchDataSuccess: () -> Void = { }
    var fetchDataFailure: (String) -> Void = { _ in }
    
}

// MARK: - Methods
extension HistoryViewModel {
    
    func getListHistory(tokenType: String,
                        pageIndex: Int,
                        pageSize: Int) {
        NetworkManager.shared.getListHistory(tokenType: tokenType,
                                             pageIndex: pageIndex,
                                             pageSize: pageSize) { result in
            switch result {
            case .success(let historyList):
                if historyList.errorCode == .SUCCESSFUL {
                    self.listHistory = historyList.data
                    self.fetchDataSuccess()
                } else {
                    self.fetchDataFailure(historyList.errorCode.message)
                }
            case .failure(let error):
                self.fetchDataFailure(error.message)
            }
        }
    }
    
}
