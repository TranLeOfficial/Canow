//
//  TopupNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func topUpGiftCard(giftcardId: String,
                              completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "giftcardId": giftcardId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.topupGiftCard,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getGiftCard(giftCardId: String,
                            completion: ((Swift.Result<GiftCard, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.giftCard + giftCardId,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func getTransactionStatus(transactionId: String,
                                     completion: ((Swift.Result<TransactionStatusRedeem, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.transactionInfo + transactionId,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func topUpCard(amount: Int,
                          completion: ((Swift.Result<TopupCard, NetworkError>) -> Void)? = nil) {
        let params = [
            "amount": amount
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.topupCard,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
}
