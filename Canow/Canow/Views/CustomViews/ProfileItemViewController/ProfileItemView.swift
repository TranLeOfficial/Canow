//
//  ProfileItemView.swift
//  Canow
//
//  Created by PhuNT14 on 23/10/2021.
//

import UIKit

class ProfileItemView: UIView {
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var floatingLabel: UILabel! {
        didSet {
            self.floatingLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var innerView: UIView! {
        didSet {
            self.innerView.clipsToBounds = true
            self.innerView.backgroundColor = .clear
        }
    }
    @IBOutlet private weak var bottomBorderView: UIView!
    @IBOutlet weak var dropDownTextField: UITextField! {
        didSet {
            self.dropDownTextField.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Proterties
    @IBInspectable
    var placeholder: String? {
        didSet {
            self.dropDownTextField.placeholder = placeholder ?? ""
        }
    }
    
    @IBInspectable
    var floatingLabelColor: UIColor = .colorB8B8B8 {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.bottomBorderView.backgroundColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    var floatingLabelBackground: UIColor = .clear {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingLabelBackground
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = .clear {
        didSet {
            self.innerView.backgroundColor = self._backgroundColor
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.innerView.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
        var textColor: UIColor? {
            didSet {
                self.dropDownTextField.textColor = textColor ?? UIColor.black
            }
        }
    
    var floatingLabelFont: UIFont = .font(with: .medium500, size: 12)
    var text: String? {
        didSet {
            self.dropDownTextField.text = text ?? ""
            self.deletePlaceHolder()
        }
    }
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        commonInit()
    }
}

// MARK: - Methods
extension ProfileItemView {
    func commonInit() {
        Bundle.main.loadNibNamed("ProfileItemView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.floatingLabel.font = self.floatingLabelFont
        self.dropDownTextField.font = .font(with: .medium500, size: 16)
        self.floatingLabel.textColor = self.floatingLabelColor
        self.floatingLabel.tag = 10
        self.setNeedsDisplay()
        self.floatingLabel.isHidden = true
        self.bottomBorderView.isHidden = false
        self.bottomBorderView.backgroundColor = .colorE5E5E5
    }
    
    func getText() -> String {
        return dropDownTextField.text ?? ""
    }
    
    private func deletePlaceHolder() {
        self.floatingLabel.text = self.placeholder
        self.floatingLabelFont = .font(with: .medium500, size: 12)
        self.floatingLabel.font = self.floatingLabelFont
        
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.isHidden = false
            self.floatingLabel.fadeIn()
        }
        self.dropDownTextField.placeholder = ""
        self.contentView.bringSubviewToFront(floatingLabel)
        self.setNeedsDisplay()
    }
    
}
