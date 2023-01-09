//
//  PartnerNetworkManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/19/21.
//

import Foundation
import Alamofire

extension NetworkManager {
    public func getPartnerListWithFantokenLogin(partnerType: String,
                                                isGroupBySport: Bool,
                                                availableFrom: String,
                                                limit: Int,
                                                sportId: Int,
                                                completion: ((Swift.Result<Partner, NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerType": partnerType,
            "isGroupBySport": isGroupBySport,
            "availableFrom": availableFrom,
            "limit": limit,
            "sportId": sportId
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.partnerList,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func getPartnerListWithFantokenWallet(partnerType: String,
                                                 isGroupBySport: Bool,
                                                 availableFrom: String,
                                                 limit: Int,
                                                 sportId: Int,
                                                 completion: ((Swift.Result<Partner, NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerType": partnerType,
            "isGroupBySport": isGroupBySport,
            "availableFrom": availableFrom,
            "limit": limit,
            "sportId": sportId
        ] as [String : Any]
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.partnerListWallet,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getTeamList(completion: ((Swift.Result<TeamList, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.teamList,
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getAllPartnerListWithFantokenLogin(partnerType: String,
                                                   isGroupBySport: Bool,
                                                   availableFrom: String,
                                                   limit: Int,
                                                   sportId: Int,
                                                   completion: ((Swift.Result<AllPartner, NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerType": partnerType,
            "isGroupBySport": isGroupBySport,
            "availableFrom": availableFrom,
            "limit": limit,
            "sportId": sportId
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.partnerList,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func getAllPartnerListWithFantokenWallet(partnerType: String,
                                                    isGroupBySport: Bool,
                                                    availableFrom: String,
                                                    limit: Int,
                                                    sportId: Int,
                                                    completion: ((Swift.Result<AllPartner, NetworkError>) -> Void)? = nil) {
        let params = [
            "partnerType": partnerType,
            "isGroupBySport": isGroupBySport,
            "availableFrom": availableFrom,
            "limit": limit,
            "sportId": sportId
        ] as [String : Any]
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePostRequest(url: self.baseURL + Endpoint.partnerListWallet,
                             headers: headers,
                             params: params,
                             completion: completion)
    }
    
    public func getPartnerInfomation(partnerId: Int,
                                     completion: ((Swift.Result<AllPartner, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.partner + "\(partnerId)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    public func getPartnerInfomationSelected(partnerId: Int,
                                             completion: ((Swift.Result<TeamSelected, NetworkError>) -> Void)? = nil) {
        self.makeGetRequest(url: self.baseURL + Endpoint.partner + "\(partnerId)",
                            headers: nil,
                            params: nil,
                            completion: completion)
    }
    
    // Get Infor team
    public func getPartnerInformationById(partnerId: Int,
                                          completion: ((Swift.Result<PartnerInfoById, NetworkError>) -> Void)? = nil) {
        let params = [
            "id": partnerId
        ] as [String : Any]
        let partnerId = String(partnerId)
        self.makeGetRequest(url: self.baseURL + Endpoint.teamInfo + partnerId,
                            headers: nil,
                            params: params,
                            completion: completion)
    }
    
    public func getPartnerBySportId(sportId: Int,
                                    completion: ((Swift.Result<PartnerSport, NetworkError>) -> Void)? = nil) {
        let params = [
            "sportId": sportId
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.partnerSport,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
    public func updateTeam(sportId: Int,
                           teamId: Int,
                           completion: ((Swift.Result<CommonResponse, NetworkError>) -> Void)? = nil) {
        let params = [
            "sportId": sportId,
            "teamId": teamId
        ] as [String: Any]
        
        let authorization = KeychainManager.apiIdToken() ?? ""
        let headers : HTTPHeaders = [.authorization(bearerToken: authorization)]
        
        self.makePutRequest(url: self.baseURL + Endpoint.updateSportAndTeam,
                            headers: headers,
                            params: params,
                            completion: completion)
    }
    
}
