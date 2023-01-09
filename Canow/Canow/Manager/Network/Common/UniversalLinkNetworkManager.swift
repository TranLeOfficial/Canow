//
//  UniversalLinkNetworkManager.swift
//  Canow
//
//  Created by NhiVHY on 07/03/2022.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getUniversalLinkData(deeplink: String,
                                     completion: ((Swift.Result<UniversalLinkModel, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.universalLink + deeplink,
                             headers: headers,
                             params: nil,
                             completion: completion)
    }
}
