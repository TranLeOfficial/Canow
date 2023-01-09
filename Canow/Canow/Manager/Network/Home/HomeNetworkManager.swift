//
//  HomeNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/8/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getNewsList(pageIndex: Int,
                            pageSize: Int,
                            isLogin: Bool,
                            completion: ((Swift.Result<NewsList, NetworkError>) -> Void)? = nil) {
        let params = [
            "pageIndex": pageIndex,
            "pageSize": pageSize
        ] as [String : Any]
        
        var headers: HTTPHeaders?
        if isLogin {
            let authorization = KeychainManager.apiIdToken() ?? ""
            headers = [.authorization(bearerToken: authorization)]
        }
        
        self.makePostRequest(url: self.baseURL + Endpoint.newList,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getThemeById(id: Int,
                             completion: ((Swift.Result<Theme, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makeGetRequest(url: self.baseURL + Endpoint.getTheme + "\(id)",
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func getStableTokenMobile(completion: ((Swift.Result<StableTokenMobile, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makeGetRequest(url: self.baseURL + Endpoint.stableTokenMobile,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
}
