//
//  UIFont+Extensions.swift
//  Canow
//
//  Created by hieplh2 on 24/12/2021.
//

import UIKit

extension UIFont {
    
    enum FontStyle: String {
        case black900    = "NotoSansJP-Black"
        case bold700     = "NotoSansJP-Bold"
        case medium500   = "NotoSansJP-Medium"
        case regular400  = "NotoSansJP-Regular"
        case light300    = "NotoSansJP-Light"
        case thin100     = "NotoSansJP-Thin"
    }
    
    static func font(with style: FontStyle, size: CGFloat) -> UIFont {
        if let font = UIFont(name: style.rawValue, size: size ) {
            return font
        } else {
            return .systemFont(ofSize: size)
        }
    }
    
}
