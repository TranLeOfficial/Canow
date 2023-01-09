//
//  SceneDelegate.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit
import Branch

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    public static var shared: SceneDelegate? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        DelegateManager.shared.configure()
        
        if let userActivity = connectionOptions.userActivities.first {
            BranchScene.shared().scene(scene, continue: userActivity)
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        DelegateManager.shared.refreshData()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
            BranchScene.shared().scene(scene, continue: userActivity)
      }
    
      func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            BranchScene.shared().scene(scene, openURLContexts: URLContexts)
      }
    
}
