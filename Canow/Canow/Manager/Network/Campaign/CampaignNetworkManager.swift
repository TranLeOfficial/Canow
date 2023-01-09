//
//  CampaignNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    
    public func getCrowdfunding(partnerId: Int, completion: ((Swift.Result<Crowdfunding, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.crowdFunding + "\(partnerId)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getRemittance(partnerId: Int, completion: ((Swift.Result<Remittance, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.remittance + "\(partnerId)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getCrowdFundingDetail(id: Int, completion: ((Swift.Result<CrowdFundingDetail, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.crowdFundingDetail + "\(id)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getCourseListById(id: Int, completion: ((Swift.Result<CourseList, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.courseListById + "\(id)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getRemittanceCampaign(remittanceId: Int, completion: ((Swift.Result<RemittanceCampaign, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.remittanceCampaign + "\(remittanceId)",
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func getCampaignItem(completion: ((Swift.Result<RemittanceItem, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makeGetRequest(url: self.baseURL + Endpoint.campaignItem,
                            headers: headers,
                            params: nil,
                            completion: completion)
    }
    
    public func donateNow(campaignId: Int,
                          campaignItemId: Int,
                          completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "campaignId": campaignId,
            "campaignItemId": campaignItemId
        ] as [String : Any]
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.donateNow,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func checkWhenDonate(campaignId: Int,
                                campaignItemId: Int,
                                price: Int,
                                completion: ((Swift.Result<TransactionResult, NetworkError>) -> Void)? = nil) {
        let authorization = KeychainManager.apiIdToken() ?? ""
        let params = [
            "campaignId": campaignId,
            "campaignItemId": campaignItemId,
            "price": price
        ] as [String : Any]
        let headers: HTTPHeaders = [.authorization(bearerToken: authorization)]
        self.makePostRequest(url: self.baseURL + Endpoint.checkWhenDonate,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
}
