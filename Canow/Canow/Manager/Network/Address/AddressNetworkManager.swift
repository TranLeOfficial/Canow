//
//  AddressNetworkManager.swift
//  Canow
//
//  Created by PhuNT14 on 21/10/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getAddress(completion: ((Swift.Result<UserAddress, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.address,
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
}
