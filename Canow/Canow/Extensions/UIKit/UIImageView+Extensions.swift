//
//  UIImageView+Extensions.swift
//  Canow
//
//  Created by hieplh2 on 29/12/2021.
//

import UIKit
import ImageIO

extension UIImageView {
    
    func setImageColor(_ color: UIColor?) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
}

// MARK: UIImageView + Gif
extension UIImageView {

    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}
