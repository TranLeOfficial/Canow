//
//  RedEnvelopeNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 3/2/22.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func redEnvelopeCustomerScan(id: Int,
                                        completion: ((Swift.Result<RedEnvelopeCustomerScan, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "id": id
        ] as [String : Any]
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.scanQREnvalope,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
}
