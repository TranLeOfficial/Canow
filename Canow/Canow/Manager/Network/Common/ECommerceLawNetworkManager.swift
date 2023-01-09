//
//  ECommerceLawNetworkManager.swift
//  Canow
//
//  Created by PhuNT14 on 29/10/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getECommerceLaw(completion: ((Swift.Result<CommonData, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.common + "ecommerce-law-mobile",
                             headers: nil,
                             params: nil,
                             completion: completion)
    }
}
