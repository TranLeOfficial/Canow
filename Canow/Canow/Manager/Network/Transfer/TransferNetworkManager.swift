//
//  TransferNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 11/22/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getStableTokenCustomer(phoneNumber: String,
                                       completion: ((Swift.Result<StableTokenCustomer, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makeGetRequest(url: self.baseURL + Endpoint.stableCustomer + phoneNumber,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func transferStableToken(amount: Int,
                                    receiver: String,
                                    completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "amount": amount,
            "receiver": receiver
        ] as [String : Any]
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.transferStableToken,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func transferFanToken(amount: Int,
                                 receiver: String,
                                 tokenType: String,
                                 completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "amount": amount,
            "receiver": receiver,
            "tokenType": tokenType
        ] as [String : Any]
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.transferFT,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getListReceiver(phoneNumber: String,
                                completion: ((Swift.Result<ReceiverTransfer, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "attribute": phoneNumber
        ] as [String : Any]
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.receiverList,
                            headers: headers,
                            params: params,
                            completion: completion)
    }
    
}
