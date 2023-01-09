//
//  DateView.swift
//  Canow
//
//  Created by NhiVHY on 12/8/21.
//

import UIKit

class DateView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.backgroundColor = .clear
        }
    }
    
    @IBOutlet private weak var innerView: UIView! {
        didSet {
            self.innerView.clipsToBounds = true
            self.innerView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var customTextField: UITextField! {
        didSet {
            self.customTextField.backgroundColor = .clear
            self.customTextField.tintColor = .black
        }
    }
    
    @IBOutlet private weak var chooseDateButton: UIButton!
    @IBOutlet private weak var floatingLabel: UILabel! {
        didSet {
            self.floatingLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var bottomBorderView: UIView!
    
    // MARK: - Proterties
    @IBInspectable
    var placeholder: String? {
        didSet {
            self.customTextField.placeholder = placeholder ?? ""
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
                self.customTextField.textColor = textColor ?? UIColor.black
            }
        }
    
    var chooseDate: () -> Void = {}
    var floatingLabelFont: UIFont = .font(with: .medium500, size: 12)
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
}

// MARK: - Methods
extension DateView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DateView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        
        self.customTextField.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.customTextField.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        self.floatingLabel.font = self.floatingLabelFont
        self.customTextField.font = .font(with: .medium500, size: 16)
        self.floatingLabel.textColor = self.floatingLabelColor
        self.floatingLabel.tag = 10
        self.setNeedsDisplay()
        self.floatingLabel.isHidden = true
        self.bottomBorderView.isHidden = false
        self.bottomBorderView.backgroundColor = .colorE5E5E5
    }
    
    private func deletePlaceHolder() {
        self.floatingLabel.text = self.placeholder
        self.floatingLabelFont = .font(with: .medium500, size: 12)
        self.floatingLabel.font = self.floatingLabelFont
        
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.isHidden = false
            self.floatingLabel.fadeIn()
        }
        self.customTextField.placeholder = ""
        self.contentView.bringSubviewToFront(floatingLabel)
        self.setNeedsDisplay()
    }
    
    func updateChooseDate(date: Date) {
        self.deletePlaceHolder()
        self.customTextField.text = date.toStringProfile(dateFormat: DateFormat.DATE_PROFILE)
    }
    
    func getDate() -> String {
        return self.customTextField.text ?? ""
    }
    
}

// MARK: - Actions
extension DateView {
    
    @IBAction func chooseDateAction(_ sender: UIButton) {
        self.chooseDate()
    }
    
    @objc func addFloatingLabel() {
        self.deletePlaceHolder()
    }
    
    @objc func removeFloatingLabel() {
        if self.customTextField.text == "" {
            UIView.animate(withDuration: 0.2) {
                if let removable = self.viewWithTag(10) {
                    removable.fadeOut()
                }
                self.floatingLabelFont = .font(with: .medium500, size: 16)
                self.floatingLabel.isHidden = true
                self.setNeedsDisplay()
            }
            self.customTextField.placeholder = self.placeholder
        }
    }
    
}
