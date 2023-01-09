//
//  UIScrollView+Extensions.swift
//  Canow
//
//  Created by PhucNT34 on 1/6/22.
//

import UIKit

extension UIScrollView {
    
    func scrollToView(view: UIView, animated: Bool = true) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: 0,
                                            y: childStartPoint.y,
                                            width: 1,
                                            height: self.frame.height),
                                     animated: animated)
        }
    }
    
    func scrollToTop(animated: Bool = true) {
        let topOffset = CGPoint(x: 0, y: -self.contentInset.top)
        self.setContentOffset(topOffset, animated: animated)
    }
    
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height + self.contentInset.bottom)
        self.setContentOffset(bottomOffset, animated: true)
    }
    
}
