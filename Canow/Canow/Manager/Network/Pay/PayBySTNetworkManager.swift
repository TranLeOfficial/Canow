//
//  PayBySTNetworkManager.swift
//  Canow
//
//  Created by Zan on 02/12/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func payByST(partnerId: Int,
                        amount: Int,
                        completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "partnerId": partnerId,
            "amount": amount
        ] as [String : Any]
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.payByST,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
}
