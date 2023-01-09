//
//  SetPasswordViewController.swift
//  Canow
//
//  Created by PhuNT14 on 13/10/2021.
//
//  Screen ID: S01004

import UIKit

enum PasswordType {
    case register, forgot
}

class SetPasswordViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var bgSetPassImageView: UIImageView!
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var topConstraintPassword: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraintContinueButton: NSLayoutConstraint!
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s01PasswordSetting.localized, color: .colorBlack111111)
            self.headerView.bgColor = .colorYellowFFCC00
            self.headerView.backButtonHidden = false
            self.headerView.rightButtonHidden = true
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet private weak var passwordTextField: FloatingLabelTextField! {
        didSet {
            self.passwordTextField.cornerRadius = 8
            self.passwordTextField.type = .secure
            self.passwordTextField.keyboardType = .default
            self.passwordTextField.returnType = .next
            self.passwordTextField.customTextField.isSecureTextEntry = true
            self.passwordTextField.placeholder = StringConstants.s01PasswordPlaceholder.localized
            self.passwordTextField.customTextField.becomeFirstResponder()
            self.passwordTextField.delegate = self
        }
    }
    @IBOutlet private weak var confirmPasswordTextField: FloatingLabelTextField! {
        didSet {
            self.confirmPasswordTextField.cornerRadius = 8
            self.confirmPasswordTextField.type = .secure
            self.confirmPasswordTextField.keyboardType = .default
            self.confirmPasswordTextField.returnType = .done
            self.confirmPasswordTextField.customTextField.isSecureTextEntry = true
            self.confirmPasswordTextField.placeholder = StringConstants.s01RetypePasswordPlaceHolder.localized
            self.confirmPasswordTextField.delegate = self
        }
    }
    @IBOutlet private weak var checkCharactorLongRadiButton: RadioButton! {
        didSet {
            self.checkCharactorLongRadiButton.titleLabel.text = StringConstants.s01LbPasswordCharacter.localized
            self.checkCharactorLongRadiButton.isEnabled = false
        }
    }
    @IBOutlet private weak var checkletterRadiButton: RadioButton! {
        didSet {
            self.checkletterRadiButton.titleLabel.text = StringConstants.s01LbPasswordInclude.localized
            self.checkletterRadiButton.isEnabled = false
        }
    }
    @IBOutlet private weak var passwordMustLabel: UILabel! {
        didSet {
            self.passwordMustLabel.text = StringConstants.s01LbPasswordMust.localized
            self.passwordMustLabel.font = .font(with: .bold700, size: 12)
            self.passwordMustLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var checkNumberRadiButton: RadioButton! {
        didSet {
            self.checkNumberRadiButton.titleLabel.text = StringConstants.s01LbPasswordNumber.localized
            self.checkNumberRadiButton.isEnabled = false
        }
    }
    @IBOutlet private weak var checkSpecialRadiButton: RadioButton! {
        didSet {
            self.checkSpecialRadiButton.titleLabel.text = "Special characters (! ? _ 0 + @, etc)"
            self.checkSpecialRadiButton.isEnabled = false
            self.checkSpecialRadiButton.isHidden = true
        }
    }
    @IBOutlet private weak var checkMatchedRadiButton: RadioButton! {
        didSet {
            self.checkMatchedRadiButton.titleLabel.text = StringConstants.s01LbPasswordMatch.localized
            self.checkMatchedRadiButton.isEnabled = false
        }
    }
    @IBOutlet private weak var continueButton: UIButton! {
        didSet {
            self.continueButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.continueButton.layer.cornerRadius = 6
            self.continueButton.tintColor = .color646464
            self.continueButton.backgroundColor = .colorE5E5E5
            self.continueButton.setTitle(StringConstants.s02BtnContinue.localized, for: .normal)
            self.continueButton.setTitle(StringConstants.s02BtnContinue.localized, for: .highlighted)
        }
    }
    
    // MARK: - Properties
    var phone: String?
    var passwordType: PasswordType = .register
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        
    }
    
}

// MARK: - Methods
extension SetPasswordViewController {
    
    func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        self.passwordTextField.onShouldReturn = {
            self.confirmPasswordTextField.customTextField.becomeFirstResponder()
        }
        self.confirmPasswordTextField.onShouldReturn = {
            self.view.endEditing(true)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func validatePassword() -> Bool {
        return self.checkletterRadiButton.selected
        && self.checkMatchedRadiButton.selected
        && self.checkNumberRadiButton.selected
        //        && self.checkSpecialRadiButton.selected
        && self.checkCharactorLongRadiButton.selected
    }
    
}

// MARK: - Actionss
extension SetPasswordViewController {
    
    @IBAction func setPassword(_ sender: Any) {
        if let phone = self.phone, let password = self.passwordTextField.text {
            let view = OTPVerifyViewController()
            view.phone = phone
            view.password = password
            view.passwordType = passwordType
            self.push(viewController: view)
            CommonManager.hideLoading()
        }
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.bottomConstraintContinueButton.constant = isKeyboardShowing ? keyboardFrame.height + 14 : 50
                self.bgSetPassImageView.isHidden = isKeyboardShowing
                self.topConstraintPassword.constant = isKeyboardShowing ? (self.bgSetPassImageView.frame.height + 7) * -1 :  16
                self.view.layoutIfNeeded()
            })
        }
    }
    
}

extension SetPasswordViewController: FloatingTextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            if textField == self.passwordTextField.customTextField {
                self.checkCharactorLongRadiButton.selected = text.count >= 8
                self.checkletterRadiButton.selected = Validation.validateTextInput(str: text, pattern: .letter)
                self.checkNumberRadiButton.selected = Validation.validateTextInput(str: text, pattern: .number)
                //                self.checkSpecialRadiButton.selected = Validation.validateTextInput(str: text, pattern: .specialCharacter)
            }
            self.checkMatchedRadiButton.selected = self.passwordTextField.text == self.confirmPasswordTextField.text && !(self.passwordTextField.text?.isEmpty ?? true)
            if validatePassword() {
                self.continueButton.isEnabled = true
                self.continueButton.setTitleColor(.colorBlack111111, for: .normal)
                self.continueButton.backgroundColor = .colorYellowFFCC00
            } else {
                self.continueButton.isEnabled = false
                self.continueButton.setTitleColor(.color646464, for: .normal)
                self.continueButton.backgroundColor = .colorE5E5E5
            }
        }
    }
    
}
