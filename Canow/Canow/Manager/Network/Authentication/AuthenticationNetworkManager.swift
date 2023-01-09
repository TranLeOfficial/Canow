//
//  LoginNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func login(username: String,
                      password: String,
                      isCustomer: Bool = true,
                      completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        let params = [
            "username": username,
            "password": password,
            "isCustomer": isCustomer
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.signin,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func getInfoCustomer(completion: ((Swift.Result<Customer, NetworkError>) -> Void)? = nil) {
        
        guard let authorization = KeychainManager.apiIdToken(),
              let phoneNumber = KeychainManager.phoneNumber() else {
                  completion?(.failure(NetworkError(StringConstants.ERROR_CODE_401)))
                  return
              }
        
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makeGetRequest(url: self.baseURL + Endpoint.customerInfo + phoneNumber,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func getReceiverInfo(phoneNumber: String,
                                completion: ((Swift.Result<Customer, NetworkError>) -> Void)? = nil) {
        
        guard let authorization = KeychainManager.apiIdToken() else {
                  completion?(.failure(NetworkError(StringConstants.ERROR_CODE_401)))
                  return
              }
        
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makeGetRequest(url: self.baseURL + Endpoint.customerInfo + phoneNumber,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    // MARK: - Forgot password
    public func forgotPassword(username: String,
                               isResetOTP: Bool,
                               completion: ((Swift.Result<Authentication,
                                             NetworkError>) -> Void)? = nil) {
        let params = [
            "username": username,
            "isResetOTP":  isResetOTP
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.customerForgetPassword,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func sendOTPRegister(phone: String,
                                completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        let params = [
            "phone": phone
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.customer,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func checkAccountExist(phone: String,
                                  completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let params = [
            "phone": phone
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.checkExist,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func checkAccountNotExist(phone: String,
                                     completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let params = [
            "phone": phone
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.checkNotExist,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func verifyOTP(phone: String,
                          otp: String,
                          completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        let params = [
            "phone": phone,
            "otp": otp
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.customerVerifyOTP,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func confirmForgotPassword(otp: String,
                                      username: String,
                                      password: String,
                                      completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        let params = [
            "confirmationCode": otp,
            "password": password,
            "username": username
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.customerConfirmForgotPassword,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func resendOTP(phone: String,
                          completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.customerResendOTP + "\(phone)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func firstSetPassword(username: String,
                                 password: String,
                                 completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        let params = [
            "username": username,
            "password": password
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.customerSetPassword,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func updateProfile(bearerToken: String,
                              phone: String,
                              name: String,
                              gender: String,
                              birthday: String = "2021-10-20T02:48:40.266Z",
                              addressId: Int = 0,
                              teamId: Int = 0,
                              completion: ((Swift.Result<Authentication, NetworkError>) -> Void)? = nil) {
        let headers: HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        let params = [
            "phone": phone,
            "name": name,
            "gender": gender,
            "birthday": birthday,
            "addressId": addressId,
            "teamId": teamId
        ] as [String : Any]
        
        self.makePutRequest(url: self.baseURL + Endpoint.updateProfile,
                            headers: headers,
                            params: params,
                            completion: completion)
    }
    
    public func updateLanguage(language: String,
                               completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let username = KeychainManager.phoneNumber() ?? ""
        let params = [
            "username": username,
            "language": language
        ] as [String : Any]
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePutRequest(url: self.baseURL + Endpoint.updateLanguage,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
}
