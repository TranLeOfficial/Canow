//
//  DelegateManager.swift
//  Canow
//
//  Created by hieplh2 on 10/04/21.
//

import Foundation
import IQKeyboardManagerSwift
import Localize
import SnapKit
import UIKit

class DelegateManager {
    
    // MARK: - Properties
    static let shared = DelegateManager()
    
    private var viewModel = FakeLaunchScreenViewModel()
    
    init() {
        self.setupData()
    }
    
}

// MARK: - Methods
extension DelegateManager {
    
    func setupData() {
        self.viewModel.fetchDataFailure = { _ in
            
        }
    }
    
    func configure() {
        Localize.update(fileName: "Localizable")
        
        self.handleDeleteKeychainWhenFirstTimeInsstallApp()
        
        self.configRouter()
        
        _ = ConnectionManager.shared
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .default
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func setRootViewController(_ viewController: UIViewController,
                               navigationBarHidden: Bool = true) {
        let window: UIWindow? = {
            if #available(iOS 13.0, *) {
                return SceneDelegate.shared?.window
            } else {
                return AppDelegate.shared?.window
            }
        }()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(navigationBarHidden, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func handleDeleteKeychainWhenFirstTimeInsstallApp() {
        if !(UserDefaultManager.alreadyInstalled ?? false) {
            CommonManager.clearData()
            UserDefaultManager.alreadyInstalled = true
        }
    }
    
    func refreshData() {
        self.viewModel.getCustomerInfo()
    }
    
    private func configRouter() {
        let fakeLaunchScreenVC = FakeLaunchScreenViewController()
        fakeLaunchScreenVC.didFetchDataSuccess = {
            self.setRootViewController(TabBarViewController(type: .home))
        }
        fakeLaunchScreenVC.didFetchDataFailure = {
            CommonManager.clearData()
            Localize.update(language: UserDefaultManager.language ?? Localize.currentLanguage)
            self.setRootViewController(TabBarViewController(type: .landingPage))
        }
        self.setRootViewController(fakeLaunchScreenVC)
    }
    
    func handleLinking(_ params: [AnyHashable: Any]?, _ error: Error?) {
        if let json = params as? [String : Any] {
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let rsp = try JSONDecoder().decode(UniversalLinkData.self, from: data)
                if rsp.creationSource != nil {
                    DataManager.shared.saveUniversalLinkData(universalLinkData: rsp)
                    if KeychainManager.apiIdToken() == nil {
                        NotificationCenter.default.post(name: NSNotification.Login, object: nil)
                    } else {
                        self.setRootViewController(TabBarViewController(type: .home))
                        NotificationCenter.default.post(name: NSNotification.universalLink, object: nil)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
