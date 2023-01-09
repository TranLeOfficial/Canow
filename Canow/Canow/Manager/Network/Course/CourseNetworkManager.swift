//
//  CourseNetworkManager.swift
//  Canow
//
//  Created by hieplh2 on 06/12/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getCourse(id: String,
                          completion: ((Swift.Result<CourseDetail, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.courseMobile + id,
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func checkRedeemCourse(id: String,
                                  completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        let params = [
            "couponId": id
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.checkRedeemCourse,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func redeemCourse(id: String,
                             completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        let params = [
            "couponId": id
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.redeemCourse,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
}
