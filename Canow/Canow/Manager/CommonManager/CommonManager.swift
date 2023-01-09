//
//  LoadingManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/12/21.
//

import Foundation
import UIKit
import Localize

class CommonManager {
    
    private static var loadingView: LoadingView?
    private static var loginView: LoginView?
    private static var timeOutView: TimeOutView?
    private static var toastView: ToastView?
    public static var checkLanguageJP: Bool {
        return Localize.shared.currentLanguage == "ja"
    }
    
}

// MARK: - Loading
extension CommonManager {
    
    public class func showLoading() {
        if self.loadingView == nil {
            self.loadingView = LoadingView()
            if let window = UIWindow.key, let loadingView = self.loadingView {
                window.addSubview(loadingView)
                
                loadingView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    public class func hideLoading() {
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
    }
    
}

// MARK: - Login
extension CommonManager {
    
    public class func showLogin() {
        if self.loginView == nil {
            self.loginView = LoginView()
            if let window = UIWindow.key, let loginView = self.loginView {
                window.addSubview(loginView)
                
                loginView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    public class func hideLogin() {
        self.loginView?.removeFromSuperview()
        self.loginView = nil
    }
    
}

// MARK: - TimeOut
extension CommonManager {
    
    public class func showTimeOut() {
        if self.timeOutView == nil && KeychainManager.apiIdToken() != nil {
            self.timeOutView = TimeOutView()
            if let window = UIWindow.key, let timeOutView = self.timeOutView {
                window.addSubview(timeOutView)
                
                timeOutView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    public class func hideTimeOut() {
        self.timeOutView?.removeFromSuperview()
        self.timeOutView = nil
    }
    
}

// MARK: - Toast
extension CommonManager {
    
    public class func showToast(icon: UIImage?,
                                message: String,
                                messageColor: UIColor = .white,
                                bgColor: UIColor?) {
        if self.toastView == nil {
            self.toastView = ToastView()
            
            if let window = UIWindow.key, let toastView = self.toastView {
                toastView.icon = icon
                toastView.message = message
                toastView.messageColor = messageColor
                toastView.bgColor = bgColor
                toastView.alpha = 0
                toastView.onClose = {
                    self.hideToast()
                }
                window.addSubview(toastView)
                
                toastView.snp.makeConstraints { make in
                    make.leading.equalTo(16)
                    make.trailing.equalTo(-16)
                    make.top.equalToSuperview().offset(44)
                }
                
                toastView.fadeIn(completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.hideToast()
                    }
                })
            }
        }
    }
    
    private class func hideToast() {
        self.toastView?.fadeOut(completion: { _ in
            self.toastView?.removeFromSuperview()
            self.toastView = nil
        })
    }
    
    class func showNoNetworkToast() {
        self.showToast(icon: UIImage(named: "ic_toast_no_network"),
                       message: StringConstants.internetMessageDisconnected.localized,
                       messageColor: .white,
                       bgColor: .color646464)
    }
    
}

extension CommonManager {
    
    public class func openApplicationSettings() {
        CommonManager.openURL(UIApplication.openSettingsURLString)
    }
    
    public class func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    public class func getImageURL(_ name: String?) -> URL? {
        guard let name = name,
              let escapedString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                  return nil
              }
        return URL(string: NetworkManager.shared.baseURLImage + escapedString)
    }
    
    public class func checkAuthenticateError(_ error: String) -> Bool {
        if error == StringConstants.ERROR_CODE_401 || error == StringConstants.ERROR_CODE_403 {
            CommonManager.showTimeOut()
            return false
        }
        return true
    }
    
    public class func checkLandingPage() -> Bool {
        if KeychainManager.apiIdToken() == nil {
            CommonManager.showLogin()
            return false
        }
        return true
    }
    
}

extension CommonManager {
    
    public class func clearData() {
        KeychainManager.deleteApiIdToken()
        KeychainManager.deleteApiRefreshToken()
        KeychainManager.deleteApiAccessToken()
        
        if !(UserDefaultManager.isRemember ?? false) {
            KeychainManager.deletePhoneNumber()
            KeychainManager.deletePassword()
        }
        
        UserDefaultManager.themeId = nil
        NotificationCenter.default.post(name: NSNotification.themeChanged, object: nil)
        
        DataManager.shared.deleteAll()
    }
    
}

extension CommonManager {
    
    public class func getImageName() -> String {
        return "IMG_\(Date().toString(dateFormat: DateFormat.DATE_IMAGE)).HEIC"
    }
    
}

extension CommonManager {
    
    public class func getHTML(data: String) -> String {
        let header = """
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                    <style>
                        body {
                            font-size: 16px;
                        }
                    </style>
                </head>
                <body>
                """
        return header + data + "</body>"
    }
    
}
