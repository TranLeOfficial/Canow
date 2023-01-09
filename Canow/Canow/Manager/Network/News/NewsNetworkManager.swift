//
//  NewsNetworkManager.swift
//  Canow
//
//  Created by PhuNT14 on 14/11/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getNewDetail(newsId: Int,
                             completion: ((Swift.Result<NewDetail, NetworkError>) -> Void)? = nil) {
        let params = [
            "id": newsId
        ] as [String : Any]
        let newsId = String(newsId)
        self.makeGetRequest(url: self.baseURL + Endpoint.newDetail + newsId,
                            headers: nil,
                            params: params,
                            completion: completion)
    }
    
}
