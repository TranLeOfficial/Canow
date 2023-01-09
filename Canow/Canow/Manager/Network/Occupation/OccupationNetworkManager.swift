//
//  OccupationNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/31/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getOccupation(completion: ((Swift.Result<Occupation, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.occupation,
                             headers: nil,
                             params: nil,
                             completion: completion)
    }
    
}
