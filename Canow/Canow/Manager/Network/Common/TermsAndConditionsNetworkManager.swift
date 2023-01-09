//
//  TermsAndConditions.swift
//  Canow
//
//  Created by PhuNT14 on 26/10/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getTermsAndConditions(completion: ((Swift.Result<CommonData, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.common + "term-condition-mobile",
                             headers: nil,
                             params: nil,
                             completion: completion)
    }
}
