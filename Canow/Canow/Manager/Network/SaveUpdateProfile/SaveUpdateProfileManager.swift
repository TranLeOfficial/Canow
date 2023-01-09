//
//  SaveUpdateProfileManager.swift
//  Canow
//
//  Created by NhanTT13 on 12/3/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func saveUpdateProfile(name: String,
                                  gender: String,
                                  birthday: String,
                                  occupationId: Int,
                                  addressId: Int,
                                  avatar: String,
                                  completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        let params = [
            "name": name,
            "gender": gender,
            "birthday": birthday,
            "occupationId": occupationId,
            "addressId": addressId,
            "avatar": avatar
        ] as [String : Any]
        
        self.makePutRequest(url: self.baseURL + Endpoint.editProfile,
                            headers: headers,
                            params: params,
                            completion: completion)
    }
    
    public func saveProfileWhenSignUp(idToken: String,
                                      name: String,
                                      gender: String,
                                      birthday: String,
                                      occupationId: Int,
                                      addressId: Int,
                                      teamId: Int,
                                      sportId: Int,
                                      avatar: String,
                                      completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let params = [
            "name": name,
            "gender": gender,
            "birthday": birthday,
            "occupationId": occupationId,
            "addressId": addressId,
            "teamId": teamId,
            "sportId": sportId,
            "avatar": avatar
        ] as [String : Any]
        let headers : HTTPHeaders = [.authorization(bearerToken: idToken)]
        self.makePutRequest(url: self.baseURL + Endpoint.saveProfileWhenSignUp,
                            headers: headers,
                            params: params,
                            completion: completion)
    }
    
    public func uploadProfileAvatar(image: UIImage,
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
    
    public func updateAvatar(avatar: String,
                             completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        let params = [
            "avatar": avatar
        ] as [String : Any]
        
        self.makePutRequest(url: self.baseURL + Endpoint.updateAvatar,
                            headers: headers,
                            params: params,
                            completion: completion)
    }
    
}
