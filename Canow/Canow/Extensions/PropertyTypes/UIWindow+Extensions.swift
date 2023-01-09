//
//  UIWindow+Extensions.swift
//  Canow
//
//  Created by TuanBM6 on 10/12/21.
//

import UIKit

extension UIWindow {
    
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
}
