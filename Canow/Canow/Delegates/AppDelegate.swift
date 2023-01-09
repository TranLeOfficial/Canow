//
//  AppDelegate.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit
import Firebase
import Branch

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    public static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
        
        DelegateManager.shared.configure()
        
        // Set true if you are using the TEST key
        switch App.environment {
        case .development, .qa, .uat:
            Branch.setUseTestBranchKey(true)
        case .production:
            Branch.setUseTestBranchKey(false)
        }
        
        if #available(iOS 13.0, *) {
            BranchScene.shared().initSession(launchOptions: launchOptions, registerDeepLinkHandler: { (params, error, scene) in
                DelegateManager.shared.handleLinking(params, error)
            })
        } else {
            Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
                DelegateManager.shared.handleLinking(params, error)
            }
        }
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        DelegateManager.shared.refreshData()
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        return Branch.getInstance().continue(userActivity)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)
    }
    
}
