//
//  UIApplication.swift
//  Canow
//
//  Created by TuanBM6 on 10/12/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func presentedViewController(base: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return presentedViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return presentedViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return presentedViewController(base: presented)
        }
        return base
    }
    
}
