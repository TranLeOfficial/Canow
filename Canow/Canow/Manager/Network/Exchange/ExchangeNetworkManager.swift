//
//  ExchangeNetworkManager.swift
//  Canow
//
//  Created by NhanTT13 on 11/23/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func postExchangeStableToken(partnerId: Int,
                                        amount: Int,
                                        completion: ((Swift.Result<TransactionResult,
                                                      NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerId": partnerId,
            "amount": amount
        ] as [String : Any]
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.exchange,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
}
