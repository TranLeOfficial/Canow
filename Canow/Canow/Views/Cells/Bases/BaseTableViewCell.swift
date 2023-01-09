//
//  BaseTableViewCell.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func configure<T>(data: T) {}
    func configure<T>(data: T, indexPath: IndexPath) {}

}
