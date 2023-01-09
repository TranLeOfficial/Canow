//
//  AuthenticationInfo.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

struct AuthenticationInfo: Decodable {
    let idToken: IdToken?
    let refreshToken: RefreshToken?
    let accessToken: AccessToken?
    let clockDrift: Int?
    let status: String?
    let name: String?
}
