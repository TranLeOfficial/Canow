//
//  SignUpViewController.swift
//  Canow
//
//  Created by PhuNT14 on 11/10/2021.
//
//  Screen ID: S01001

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentView.backgroundColor = .white
        }
    }
    @IBOutlet private weak var bottomConstraintResentButton: NSLayoutConstraint!
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s01TitleHeader.localized, color: .colorBlack111111)
            self.headerView.bgColor = .colorYellowFFCC00
            self.headerView.rightButtonHidden = false
            self.headerView.backButtonHidden = true
            self.headerView.onPressRightButton = {
                NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                self.popToRoot()
            }
        }
    }
    @IBOutlet private weak var termsLabel: UILabel! {
        didSet {
            self.termsLabel.textColor = .colorBlack111111
            self.termsLabel.font = .font(with: .medium500, size: 12)
            self.termsLabel.text = StringConstants.s01TermCondition.localized
        }
    }
    @IBOutlet private weak var termsTwoLabel: UILabel! {
        didSet {
            self.termsTwoLabel.textColor = .colorBlack111111
            self.termsTwoLabel.font = .font(with: .medium500, size: 12)
            self.termsTwoLabel.text = StringConstants.s01TermCondition.localized
        }
    }
    @IBOutlet private weak var tearmButton: UIButton! {
        didSet {
            self.tearmButton.setTitle(StringConstants.s01BtnTermCondition.localized, for: .normal)
            self.tearmButton.titleLabel?.font = .font(with: .medium500, size: 12)
            let name = StringConstants.s01BtnTermCondition.localized
            let font = UIFont.font(with: .medium500, size: 12)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (name as NSString).size(withAttributes: fontAttributes)
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor.black.cgColor
            bottomBorder.frame = CGRect(x: self.tearmButton.bounds.minX,
                                        y: self.tearmButton.bounds.height * 3 / 4,
                                        width: size.width,
                                        height: 1)
            self.tearmButton.layer.addSublayer(bottomBorder)
        }
    }
    
    @IBOutlet private weak var termsCheckBoxButton: CheckBoxButton! {
        didSet {
            self.termsCheckBoxButton.delegate = self
        }
    }
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            self.loginButton.setTitle(StringConstants.s01BtnLogin.localized, for: .normal)
            self.loginButton.setTitle(StringConstants.s01BtnLogin.localized, for: .highlighted)
            self.loginButton.titleLabel?.font = .font(with: .bold700, size: 16)
        }
    }
    @IBOutlet private weak var continueButton: UIButton! {
        didSet {
            self.continueButton.setTitle(StringConstants.s01BtnContinue.localized, for: .normal)
            self.continueButton.setTitle(StringConstants.s01BtnContinue.localized, for: .highlighted)
            self.continueButton.layer.cornerRadius = 6
            self.continueButton.tintColor = .color646464
            self.continueButton.backgroundColor = .colorE5E5E5
            self.continueButton.titleLabel?.font = .font(with: .bold700, size: 16)
        }
    }
    @IBOutlet private weak var messageCodeLabel: UILabel! {
        didSet {
            self.messageCodeLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var messageCodeView: UIView!
    @IBOutlet private weak var termView: UIView!
    @IBOutlet private weak var phoneTextField: FloatingLabelTextField! {
        didSet {
            self.phoneTextField.cornerRadius = 8
            self.phoneTextField.type = .normal
            self.phoneTextField.placeholder = StringConstants.s01PhonePlaceholder.localized
            self.phoneTextField.keyboardType = .numberPad
            self.phoneTextField.textCount = Constants.PHONE_COUNT
            self.phoneTextField.didBeginEditing = {
                self.messageCodeView.isHidden = true
            }
            self.phoneTextField.delegate = self
        }
    }
    
    // MARK: - Properties
    private let viewModel = SignUpViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.checkAccountExistedSuccess()
        self.checkAccountExistedFailure()
    }
}

// MARK: - Methods
extension SignUpViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        self.phoneTextField.customTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        if CommonManager.checkLanguageJP {
            self.termsLabel.isHidden = true
            self.termsTwoLabel.isHidden = false
        }
    }
    
    private func handleFailure() {
        self.phoneTextField.changeState(state: .error)
        self.messageCodeView.isHidden = false
    }
    
    func checkAccountExistedSuccess() {
        self.viewModel.checkAccountExistedSuccess = {
            self.gotoSetPassword()
            CommonManager.hideLoading()
        }
    }
    
    func checkAccountExistedFailure() {
        self.viewModel.checkAccountExistedFailure = { error in
            self.handleFailure()
            self.messageCodeLabel.text = "* " + error
            CommonManager.hideLoading()
        }
    }
    
    func gotoSetPassword() {
        let view = SetPasswordViewController()
        view.phone = phoneTextField.customTextField.text
        self.push(viewController: view)
    }
    
}

// MARK: - Actions
extension SignUpViewController {
    
    @IBAction func signUp(_ sender: Any) {
        guard let phone = self.phoneTextField.text else { return }
        self.phoneTextField.customTextField.resignFirstResponder()
        if !self.viewModel.validatePhoneNumber(phone: phone) {
            self.handleFailure()
            self.messageCodeLabel.text = "* \(StringConstants.s01MessagePhoneError.localized)"
            return
        }
        self.viewModel.checkAccountExist(phone: phone)
    }
    
    @IBAction func backLogInView(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func gotoTermsAndConditions(_ sender: UIButton) {
        self.push(viewController: TermsAndConditionsViewController())
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.bottomConstraintResentButton.constant = isKeyboardShowing ? keyboardFrame.height + 14 : 50
                self.view.layoutIfNeeded()
            })
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: FloatingTextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.messageCodeView.isHidden = true
        if self.termsCheckBoxButton.isChecked && self.phoneTextField.text?.count == Constants.PHONE_COUNT {
            self.continueButton.isEnabled = true
            self.continueButton.tintColor = .colorBlack111111
            self.continueButton.backgroundColor = .colorYellowFFCC00
        } else {
            self.continueButton.isEnabled = false
            self.continueButton.tintColor = .color646464
            self.continueButton.backgroundColor = .colorE5E5E5
        }
    }
    
}

// MARK: - CheckBoxButton delegate
extension SignUpViewController: CheckboxButtonDelegate {
    
    func onClick(_ isChecked: Bool) {
        let phoneNumber = self.phoneTextField.text ?? ""
        if isChecked
            && phoneNumber.count <= Constants.PHONE_COUNT
            && phoneNumber != "" {
            self.continueButton.isEnabled = true
            self.continueButton.tintColor = .colorBlack111111
            self.continueButton.backgroundColor = .colorYellowFFCC00
        } else {
            self.continueButton.isEnabled = false
            self.continueButton.tintColor = .color646464
            self.continueButton.backgroundColor = .colorE5E5E5
        }
    }
    
}
