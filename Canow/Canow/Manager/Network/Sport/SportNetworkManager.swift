//
//  SportNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getSport(completion: ((Swift.Result<Sport, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.sport,
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
}
