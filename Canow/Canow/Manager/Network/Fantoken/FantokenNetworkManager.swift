//
//  FantokenNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 11/4/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getCustomerBalance(username: String,
                                   tokenType: String,
                                   completion: ((Swift.Result<FantokenBalance, NetworkError>) -> Void)? = nil) {
        let params = [
            "username": username,
            "tokenType": tokenType
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.customerBalance,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
}
