//
//  OTPView.swift
//  Canow
//
//  Created by PhuNT14 on 22/10/2021.
//

import Foundation
import UIKit

protocol OTPViewDelegate: AnyObject {
    func verifyOTP()
}

class OTPView: UIStackView {
    
    // MARK: - Properties
    var textFieldArray = [OTPTextField]()
    var numberOfOTPdigit = 6
    var borderColor: UIColor = .colorE5E5E5 {
        didSet {
            textFieldArray.forEach { $0.configBorder(borderWidth: 1, borderColor: borderColor, cornerRadius: 8) }
        }
    }
    weak var delegate: OTPViewDelegate?
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setTextFields()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setTextFields()
    }
}

// MARK: - UITextFieldDelegate
extension OTPView {
    private func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 6
    }
    
    private func setTextFields() {
        for index in 0..<numberOfOTPdigit {
            let field = OTPTextField()
            field.backgroundColor = .white
            textFieldArray.append(field)
            addArrangedSubview(field)
            OTPTextField.appearance().tintColor = .colorBlack111111
            field.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 8)
            field.delegate = self
            field.adjustsFontSizeToFitWidth = true
            field.textAlignment = .center
            field.keyboardType = .asciiCapableNumberPad
            field.font = .font(with: .bold700, size: 24)
            
            index != 0 ? (field.previousTextField = textFieldArray[index-1]) : ()
            index != 0 ? (textFieldArray[index-1].nextTextFiled = textFieldArray[index]) : ()
        }
    }
    
    func focusOTPTextfield() {
        self.borderColor = .colorE5E5E5
        if !(textFieldArray.last?.text?.isEmpty ?? true) {
            textFieldArray.last?.becomeFirstResponder()
            textFieldArray.last?.configBorder(borderWidth: 1, borderColor: .colorBlack111111, cornerRadius: 8)
        }
        for item in textFieldArray where item.text?.isEmpty ?? true {
            item.becomeFirstResponder()
            item.configBorder(borderWidth: 1, borderColor: .colorBlack111111, cornerRadius: 8)
            break
        }
    }
    
    func getOTP() -> String? {
        var OTPText = ""
        for item in textFieldArray {
            OTPText += item.text ?? ""
        }
        return OTPText
    }
    
    func clearFocus() {
        textFieldArray.forEach {
            $0.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 8)
        }
    }
}

// MARK: - UITextFieldDelegate
extension OTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? OTPTextField else {
            return true
        }
        if !string.isEmpty {
            self.borderColor = .colorE5E5E5
            field.text = string
            field.resignFirstResponder()
            field.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 8)
            field.nextTextFiled?.configBorder(borderWidth: 1, borderColor: .colorBlack111111, cornerRadius: 8)
            field.nextTextFiled?.becomeFirstResponder()
        }
        if textField == self.textFieldArray.last && string != "" {
            self.delegate?.verifyOTP()
        }
        return true
    }
}
