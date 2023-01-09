//
//  NewDetailViewModel.swift
//  Canow
//
//  Created by PhuNT14 on 14/11/2021.
//

import Foundation

class NewsDetailViewModel: NSObject {
    
    // MARK: - Properties
    var new: NewDetailInfo?
    var getNewDetailSuccess: () -> Void = { }
    var getNewDetailFailure: (String) -> Void = { _ in }
    var fetchNewsDetailSuccess: (NewDetailInfo) -> Void = { _ in }
    
}

// MARK: - Methods
extension NewsDetailViewModel {
    func getNewDetail(newsId: Int) {
        NetworkManager.shared.getNewDetail(newsId: newsId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newDetail):
                if newDetail.errorCode != .SUCCESSFUL {
                    self.getNewDetailFailure(newDetail.errorCode.message)
                } else {
                    if let data = newDetail.data {
                        self.new = data
                        guard let dataDelegate = self.new else { return  }
                        self.fetchNewsDetailSuccess(dataDelegate)
                    }
                    self.getNewDetailSuccess()
                }
            case .failure(let error):
                self.getNewDetailFailure(error.message)
            }
        }
    }
}
