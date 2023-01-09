//
//  BaseCollectionViewCell.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure<T>(data: T) {}
    func configure<T>(data: T, indexPath: IndexPath) {}

}
