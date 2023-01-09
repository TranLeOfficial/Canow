//
//  NetworkManager.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let baseURL: String = {
        switch App.environment {
        case .development:
            return "https://canow-backend-qa.akachains.io/v1/api/mobile"
        case .qa:
            return "https://canow-backend-qa.akachains.io/v1/api/mobile"
        case .uat:
            return "https://canow-backend-uat.akachains.io/v1/api/mobile"
        case .production:
            return "https://backend.yelltum.fun/v1/api/mobile"
        }
    }()
    
    let baseURLImage: String = {
        switch App.environment {
        case .development:
            return "https://canow-dev.s3-ap-southeast-1.amazonaws.com/"
        case .qa:
            return "https://canow-dev.s3-ap-southeast-1.amazonaws.com/"
        case .uat:
            return "https://canow-dev.s3-ap-southeast-1.amazonaws.com/"
        case .production:
            return "https://canow-prod.s3.ap-northeast-1.amazonaws.com/"
        }
    }()
    
}

extension NetworkManager {
    
    public func makeGetRequest<T: Decodable>(url: String,
                                             headers: HTTPHeaders?,
                                             params: Parameters?,
                                             encoding: ParameterEncoding = URLEncoding.default,
                                             completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        self.makeRequest(url: url,
                         method: .get,
                         headers: headers,
                         params: params,
                         encoding: encoding,
                         completion: completion)
    }
    
    public func makePostRequest<T: Decodable>(url: String,
                                              headers: HTTPHeaders?,
                                              params: Parameters?,
                                              encoding: ParameterEncoding = JSONEncoding.default,
                                              completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        self.makeRequest(url: url,
                         method: .post,
                         headers: headers,
                         params: params,
                         encoding: encoding,
                         completion: completion)
    }
    
    public func makePutRequest<T: Decodable>(url: String,
                                             headers: HTTPHeaders?,
                                             params: Parameters?,
                                             encoding: ParameterEncoding = JSONEncoding.default,
                                             completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        self.makeRequest(url: url,
                         method: .put,
                         headers: headers,
                         params: params,
                         encoding: encoding,
                         completion: completion)
    }
    
    public func makePatchRequest<T: Decodable>(url: String,
                                               headers: HTTPHeaders?,
                                               params: Parameters?,
                                               encoding: ParameterEncoding = JSONEncoding.default,
                                               completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        self.makeRequest(url: url,
                         method: .patch,
                         headers: headers,
                         params: params,
                         encoding: encoding,
                         completion: completion)
    }
    
    public func makeDeleteRequest<T: Decodable>(url: String,
                                                headers: HTTPHeaders?,
                                                params: Parameters?,
                                                encoding: ParameterEncoding = JSONEncoding.default,
                                                completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        self.makeRequest(url: url,
                         method: .delete,
                         headers: headers,
                         params: params,
                         encoding: encoding,
                         completion: completion)
    }
    
    private func makeRequest<T: Decodable>(url: String,
                                           method: HTTPMethod,
                                           headers: HTTPHeaders?,
                                           params: Parameters?,
                                           encoding: ParameterEncoding,
                                           completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        if ConnectionManager.shared.isConnect {
            AF.request(url,
                       method: method,
                       parameters: params,
                       encoding: encoding,
                       headers: headers,
                       interceptor: self)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success(_):
                        if let json = response.value as? [String : Any] {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: json)
                                let rsp = try JSONDecoder().decode(T.self, from: data)
                                completion?(.success(rsp))
                            } catch let error {
                                completion?(.failure(NetworkError(error.asAFError)))
                            }
                        } else {
                            completion?(.failure(NetworkError()))
                        }
                    case .failure(let error):
                        completion?(.failure(NetworkError(error.asAFError)))
                    }
                }
        } else {
            CommonManager.hideLoading()
            CommonManager.showNoNetworkToast()
            completion?(.failure(NetworkError(StringConstants.networkUnavailable.localized)))
        }
    }
    
    public func uploadImage<T: Decodable>(url:String,
                                          image: UIImage,
                                          fileName: String,
                                          method: HTTPMethod,
                                          headers: HTTPHeaders?,
                                          completion: ((Swift.Result<T, NetworkError>) -> Void)?) {
        if ConnectionManager.shared.isConnect {
            let multipartFormData: (MultipartFormData) -> Void = { formData in
                guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                    completion?(.failure(NetworkError()))
                    return
                }
                formData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/jpg")
            }
            
            AF.upload(multipartFormData: multipartFormData,
                      to: url,
                      method: method,
                      headers: headers)
                .response { (response) in
                    switch response.result {
                    case .success(let result):
                        if let data = result {
                            do {
                                let rsp = try JSONDecoder().decode(T.self, from: data)
                                completion?(.success(rsp))
                            } catch let error {
                                completion?(.failure(NetworkError(error.asAFError)))
                            }
                        } else {
                            completion?(.failure(NetworkError()))
                        }
                    case .failure(let error):
                        completion?(.failure(NetworkError(error.asAFError)))
                    }
                }
        } else {
            CommonManager.hideLoading()
            CommonManager.showNoNetworkToast()
            completion?(.failure(NetworkError(StringConstants.networkUnavailable.localized)))
        }
    }
    
}

extension NetworkManager: RequestInterceptor {
    
    internal func adapt(_ urlRequest: URLRequest,
                        for session: Session,
                        completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = KeychainManager.apiIdToken() else {
            completion(.success(urlRequest))
            return
        }
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        print("\nadapted; token added to the header field is: \(bearerToken)\n")
        completion(.success(request))
    }
    
    internal func retry(_ request: Request,
                        for session: Session,
                        dueTo error: Error,
                        completion: @escaping (RetryResult) -> Void) {
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        guard request.retryCount < 3 else {
            completion(.doNotRetry)
            return
        }
        
        print("Retry \(request.retryCount) time with statusCode....\(statusCode)")
        
        switch statusCode {
        case 200...299:
            completion(.doNotRetry)
        case 401, 403:
            self.refreshToken { result in
                switch result {
                case .success(let refreshTokenInfo):
                    KeychainManager.setApiIdToken(token: refreshTokenInfo.data.authenticationResult.idToken)
                    KeychainManager.setApiAccessToken(token: refreshTokenInfo.data.authenticationResult.accessToken)
                    completion(.retry)
                case .failure(_):
                    completion(.doNotRetry)
                }
            }
        default:
            completion(.doNotRetry)
        }
    }
    
    private func refreshToken(completion: ((Swift.Result<AppRefreshToken, NetworkError>) -> Void)? = nil) {
        let refreshToken = KeychainManager.apiRefreshToken() ?? ""
        
        let params = [
            "refreshToken": refreshToken
        ] as [String : Any]
        
        self.makePostRequest(url: self.baseURL + Endpoint.refreshToken,
                             headers: nil,
                             params: params,
                             completion: completion)
    }
    
}

class NetworkError: Error {
    
    var message = ""
    
    init(_ error: AFError?) {
        if let error = error {
            switch error.responseCode {
            case 401:
                self.message = StringConstants.ERROR_CODE_401
            case 403:
                self.message = StringConstants.ERROR_CODE_403
            case 504:
                self.message = MessageCode.E500.message
            default:
                self.message = error.localizedDescription
            }
        } else {
            self.message = StringConstants.ERROR_CODE_COMMON
        }
    }
    
    init(_ message: String = StringConstants.ERROR_CODE_COMMON) {
        self.message = message
    }
    
}
