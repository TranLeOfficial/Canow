//
//  MyQRNetworkManager.swift
//  Canow
//
//  Created by PhuNT14 on 17/11/2021.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getMyQR(values: String,
                        completion: ((Swift.Result<CommonData, NetworkError>) -> Void)? = nil) {
        let params = [
            "values": values
        ] as [String : Any]
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.myQRCode,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func uploadAvatar(image: UIImage,
                             fileName: String,
                             completion: ((Swift.Result<CommonData, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.uploadImage(url: self.baseURL + Endpoint.uploadFile,
                                 image: image,
                                 fileName: fileName,
                                 method: .post,
                                 headers: headers,
                                 completion: completion)
    }
    
    public func uploadAvatarRegister(idToken: String,
                                     image: UIImage,
                                     fileName: String,
                                     completion: ((Swift.Result<CommonData, NetworkError>) -> Void)? = nil) {
        let headers : HTTPHeaders = [.authorization(bearerToken: idToken)]
        self.uploadImage(url: self.baseURL + Endpoint.uploadFile,
                                 image: image,
                                 fileName: fileName,
                                 method: .post,
                                 headers: headers,
                                 completion: completion)
    }
    
}
