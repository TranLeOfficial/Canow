//
//  CheckBoxButton.swift
//  Canow
//
//  Created by NhiVHY on 12/7/21.
//

import UIKit

protocol CheckboxButtonDelegate: AnyObject {
    func onClick(_ isChecked: Bool)
}

class CheckBoxButton: UIButton {
    let checkedImage = UIImage(named: "ic_checkbox_checked")! as UIImage
    let uncheckedImage = UIImage(named: "ic_checkbox_blank")! as UIImage

    weak var delegate: CheckboxButtonDelegate?
    var isChecked: Bool = false {
        didSet {
            if self.isChecked {
                self.setBackgroundImage(checkedImage, for: .normal)
            } else {
                self.setBackgroundImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.setBackgroundImage(uncheckedImage, for: .normal)
    }
    
}

// MARK: - Actions
extension CheckBoxButton {
    
    @objc func buttonClicked(sender: UIButton) {
        self.isChecked = !self.isChecked
        self.delegate?.onClick(self.isChecked)
    }
    
}
