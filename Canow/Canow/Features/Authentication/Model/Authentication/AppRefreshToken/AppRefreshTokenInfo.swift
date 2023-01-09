//
//  AppRefreshTokenInfo.swift
//  Canow
//
//  Created by hieplh2 on 08/12/2021.
//

import Foundation

struct AppRefreshTokenInfo {
    let challengeParameters: ChallengeParameters?
    let authenticationResult: AuthenticationResult
}

extension AppRefreshTokenInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case challengeParameters = "ChallengeParameters"
        case authenticationResult = "AuthenticationResult"
    }
}

struct AuthenticationResult {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let idToken: String
}

extension AuthenticationResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "AccessToken"
        case expiresIn = "ExpiresIn"
        case tokenType = "TokenType"
        case idToken = "IdToken"
    }
}

struct ChallengeParameters: Decodable {
    
}
