//
//  UITableView+Extensions.swift
//  Plass
//
//  Created by hieplh2 on 1/16/21.
//

import UIKit

extension UITableView {

    // Remove the separator lines of blank cells at the bottom of tableView.
    func removeBottomSeparatorLine() {
        self.tableFooterView = UIView(frame: CGRect.zero)
    }

    func registerReusedCell<T: UITableViewCell>(cellNib: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: cellNib.dequeueIdentifier, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: cellNib.dequeueIdentifier)
    }

    func dequeueReusable<T: UITableViewCell>(cellNib: T.Type, indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: cellNib.dequeueIdentifier, for: indexPath) as? T
    }

    func dequeueReusable<T: UITableViewCell>(cellNib: T.Type) -> T? {
        return self.dequeueReusableCell(withIdentifier: cellNib.dequeueIdentifier) as? T
    }

}

extension UITableViewCell {

    static var dequeueIdentifier: String {
        return String(describing: self)
    }

}
