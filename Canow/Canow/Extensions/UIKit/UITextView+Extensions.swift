//
//  UITextView+Extensions.swift
//  Plass
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit

extension UITextView {

    enum PaddingSide {
        case top(CGFloat)
        case left(CGFloat)
        case bottom(CGFloat)
        case right(CGFloat)
    }

    func addPadding(_ padding: PaddingSide ...) {
        self.layer.masksToBounds = true

        var top: CGFloat = 0
        var left: CGFloat = 0
        var bottom: CGFloat = 0
        var right: CGFloat = 0

        for item in padding {
            switch item {
            case .top(let spacing):
                top = spacing
            case .left(let spacing):
                left = spacing
            case .bottom(let spacing):
                bottom = spacing
            case .right(let spacing):
                right = spacing
            }
        }

        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

}
