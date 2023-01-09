//
//  CouponNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getListCouponAvailable(partnerId: Int, completion: ((Swift.Result<Coupon, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.listCouponAvailable + "\(partnerId)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getListCouponPurchased(partnerId: Int, completion: ((Swift.Result<Purchased, NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerId": partnerId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.listCouponPurchased,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getCouponDetail(eCouponId: String, completion: ((Swift.Result<CouponDetail, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.couponDetail + eCouponId,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func getListCouponByMerchantId(merchantId: Int, completion: ((Swift.Result<CouponMerchant, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.listCouponMerchant + "\(merchantId)",
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func couponRedeem(couponId: String,
                             completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "couponId": couponId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.couponRedeem,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func couponUse(eCouponId: String,
                          partnerId: Int,
                          completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "eCouponId": eCouponId,
            "partnerId": partnerId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.couponUse,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func checkUseCoupon(partnerId: Int,
                               eCouponId: String,
                               completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerId": partnerId,
            "eCouponId": eCouponId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.checkUseCoupon,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func checkRedeemCoupon(couponId: String,
                                  completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "couponId": couponId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.checkRedeemCoupon,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func removeCoupon(eCouponId: String,
                             completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeDeleteRequest(url: self.baseURL + Endpoint.deleteCouponUse + eCouponId,
                               headers: headers,
                               params: nil,
                               completion: completion)
    }
    
    public func getEcouponDetail(eCouponId: String,
                                 completion: ((Swift.Result<EcouponDetail, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.eCouponDetail + "\(eCouponId)",
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func couponRedEnvelopeUse(eCouponId: String,
                                     partnerId: Int,
                                     completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "eCouponId": eCouponId,
            "partnerId": partnerId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.useCouponRedEnvelope,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func couponAirdropUse(eCouponId: String,
                                 partnerId: Int,
                                 completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let params = [
            "eCouponId": eCouponId,
            "partnerId": partnerId
        ] as [String : Any]
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.useCouponAirdrop,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
}
