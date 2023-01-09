//
//  FloatingLabelTextField.swift
//  Canow
//
//  Created by NhiVHY on 12/8/21.
//

import UIKit

enum TextFieldType {
    case normal, secure, giftCode
}

enum State {
    case normal, error, editting
}

protocol FloatingTextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidChangeSelection(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
    func handleClearTextTextField()
}

extension FloatingTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    func textFieldDidChangeSelection(_ textField: UITextField) {}
    func textFieldDidEndEditing(_ textField: UITextField) {}
    func handleClearTextTextField() {}
}

class FloatingLabelTextField: UIView {
    
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
            self.customTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var securityButton: UIButton!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var floatingLabel: UILabel!
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
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var text: String? = "" {
        didSet {
            self.customTextField.text = self.text
            if self.text == "" {
                self.removeFloatingLabel()
            } else {
                self.addFloatingLabel()
            }
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = .colorE5E5E5 {
        didSet {
            self.bottomBorderView.backgroundColor = activeBorderColor
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
    
    var type: TextFieldType = .normal {
        didSet {
            switch self.type {
            case .secure:
                self.customTextField.isSecureTextEntry = true
                self.securityButton.isHidden = false
            case .normal:
                self.customTextField.isSecureTextEntry = false
                self.securityButton.isHidden = true
            case .giftCode:
                self.customTextField.isSecureTextEntry = false
                self.securityButton.isHidden = true
            }
        }
    }
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            self.customTextField.keyboardType = self.keyboardType
        }
    }
    
    var returnType: UIReturnKeyType = .default {
        didSet {
            self.customTextField.returnKeyType = self.returnType
        }
    }
    
    var textCount: Int = 0
    
    var onShouldReturn: () -> Void = {}
    var didBeginEditing: () -> Void = {}
    var didChangeSelection: () -> Void = {}
    var didEndEditing: () -> Void = {}
    
    var floatingLabelFont: UIFont = .font(with: .medium500, size: 12)
    weak var delegate: FloatingTextFieldDelegate?
    
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
extension FloatingLabelTextField {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FloatingLabelTextField", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        
        self.customTextField.font = .font(with: .medium500, size: 16)
        self.floatingLabel.font = self.floatingLabelFont
        self.floatingLabel.textColor = self.floatingLabelColor
        self.floatingLabel.tag = 10
        
        self.floatingLabel.isHidden = true
        self.bottomBorderView.isHidden = false
        self.bottomBorderView.backgroundColor = self.activeBorderColor
        self.setNeedsDisplay()
        
        self.customTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func changeState(state: State) {
        switch state {
        case .normal:
            self.activeBorderColor = .colorE5E5E5
            self.floatingLabelColor = .colorB8B8B8
        case .error:
            self.floatingLabelColor = .colorRedEB2727
            self.activeBorderColor = .colorRedEB2727
        case .editting:
            self.activeBorderColor = .colorBlack111111
            self.floatingLabelColor = .colorBlack111111
        }
    }
    
}

// MARK: - IBActions
extension FloatingLabelTextField {
    
    @IBAction func setDisplayPassword(_ sender: Any) {
        self.securityButton.setImage(UIImage(named: self.customTextField.isSecureTextEntry ?
                                             "ic_eye_close" :
                                                "ic_eye"),
                                     for: .normal)
        self.securityButton.setImage(UIImage(named: self.customTextField.isSecureTextEntry ?
                                             "ic_eye_close" :
                                                "ic_eye"),
                                     for: .highlighted)
        self.customTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func clearText(_ sender: Any) {
        self.customTextField.becomeFirstResponder()
        self.customTextField.text = ""
        self.delegate?.handleClearTextTextField()
    }
    
}

// MARK: - UITextFieldDelegate
extension FloatingLabelTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addFloatingLabel()
        self.clearButton.isHidden = (self.customTextField.text ?? "").isEmpty
        self.changeState(state: .editting)
        self.delegate?.textFieldDidBeginEditing(textField)
        self.didBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.clearButton.isHidden = true
        self.changeState(state: .normal)
        if self.customTextField.text == "" {
            removeFloatingLabel()
        } else {
            self.addFloatingLabel()
        }
        self.delegate?.textFieldDidEndEditing(textField)
        self.didEndEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        switch self.type {
        case .giftCode:
            let text = (textFieldText as NSString)
                .replacingCharacters(in: range, with: string.uppercased())
                .filter({ Validation.validateTextInput(str: String($0), pattern: .alphaNumeric) })
            textField.text = text.format("XXXXX - XXXXX - XXXXX", oldString: textFieldText)
            DispatchQueue.main.async {
                let newPosition = textField.endOfDocument
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            return false
        default:
            return self.textCount == 0 ? true : (count <= self.textCount)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onShouldReturn()
        return true
    }
    
}

// MARK: - Methods
extension FloatingLabelTextField {
    
    func addFloatingLabel() {
        self.floatingLabel.text = self.placeholder
        self.floatingLabelFont = .font(with: .medium500, size: 12)
        self.floatingLabel.font = self.floatingLabelFont
        
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.isHidden = false
            self.floatingLabel.fadeIn()
        }
        self.contentView.bringSubviewToFront(self.floatingLabel)
        self.setNeedsDisplay()
    }
    
    private func removeFloatingLabel() {
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
    
    func setDisableRightButtons() {
        self.clearButton.isHidden = true
        self.securityButton.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        self.clearButton.isHidden = (self.customTextField.text ?? "").isEmpty
        self.text = self.customTextField.text
        
        self.delegate?.textFieldDidChangeSelection(self.customTextField)
        self.didChangeSelection()
    }
    
}
