//
//  HistoryNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 11/5/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getListHistory(tokenType: String,
                               pageIndex: Int,
                               pageSize: Int,
                               completion: ((Swift.Result<History, NetworkError>) -> Void)? = nil) {
        let params = [
            "tokenType": tokenType,
            "pageIndex": pageIndex,
            "pageSize": pageSize
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.history,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getStableToken(completion: ((Swift.Result<StableToken, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.stableToken,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func getTransactionId(transactionId: String,
                                 completion: ((Swift.Result<Transaction, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.historyDetail + transactionId,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
}
