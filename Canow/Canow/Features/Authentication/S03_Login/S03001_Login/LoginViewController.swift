//
//  LoginViewController.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import UIKit

class LoginViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s03TitleLogin.localized, color: .black, font: .font(with: .bold700, size: 16))
            self.headerView.bgColor = .colorYellowFFCC00
            self.headerView.rightButtonHidden = false
            self.headerView.backButtonHidden = true
            self.headerView.onPressRightButton = {
                NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                self.popToRoot()
            }
        }
    }
    
    @IBOutlet private weak var contentItemsView: UIView! {
        didSet {
            self.contentItemsView.layer.cornerRadius = 20
            self.contentItemsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentItemsView.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var usernameTextField: FloatingLabelTextField! {
        didSet {
            self.usernameTextField.floatingLabelFont = .font(with: .medium500, size: 16)
            self.usernameTextField.placeholder = StringConstants.s03PhoneNumberPlaceholder.localized
            self.usernameTextField.type = .normal
            self.usernameTextField.textCount = Constants.PHONE_COUNT
            self.usernameTextField.keyboardType = .numberPad
            self.usernameTextField.customTextField.addTarget(self,
                                                             action: #selector(self.setLoginEnable),
                                                             for: .editingChanged)
            self.usernameTextField.customTextField.addTarget(self,
                                                             action: #selector(self.clearError(_:)),
                                                             for: .editingDidBegin)
            self.usernameTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var passwordTextField: FloatingLabelTextField! {
        didSet {
            self.passwordTextField.floatingLabelFont = .font(with: .medium500, size: 16)
            self.passwordTextField.placeholder = StringConstants.s03PasswordPlaceholder.localized
            self.passwordTextField.type = .secure
            self.passwordTextField.returnType = .done
            self.passwordTextField.customTextField.addTarget(self,
                                                             action: #selector(self.setLoginEnable),
                                                             for: .editingChanged)
            self.passwordTextField.customTextField.addTarget(self,
                                                             action: #selector(self.clearError(_:)),
                                                             for: .editingDidBegin)
            self.passwordTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var messageErrorView: UIView!
    @IBOutlet private weak var messageErrorLabel: UILabel! {
        didSet {
            self.messageErrorLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var forgotPasswordButon: UIButton! {
        didSet {
            self.forgotPasswordButon.setTitle(StringConstants.s03ForgotPassword.localized, for: .normal)
            self.forgotPasswordButon.setTitle(StringConstants.s03ForgotPassword.localized, for: .highlighted)
            let name = StringConstants.s03ForgotPassword.localized
            let font = UIFont.font(with: .medium500, size: 12)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (name as NSString).size(withAttributes: fontAttributes)
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor.black.cgColor
            bottomBorder.frame = CGRect(x: self.forgotPasswordButon.bounds.minX,
                                        y: self.forgotPasswordButon.bounds.height * 3.5 / 4,
                                        width: size.width,
                                        height: 1)
            self.forgotPasswordButon.layer.addSublayer(bottomBorder)
        }
    }
    @IBOutlet private weak var signUpButton: UIButton! {
        didSet {
            self.signUpButton.setTitle(StringConstants.s03NewMember.localized, for: .normal)
            self.signUpButton.setTitle(StringConstants.s03NewMember.localized, for: .highlighted)
            let bottomBorder = CALayer()
            bottomBorder.backgroundColor = UIColor.black.cgColor
            bottomBorder.frame = CGRect(x: self.signUpButton.bounds.minX,
                                        y: self.signUpButton.bounds.height * 3 / 4,
                                        width: self.signUpButton.titleLabel?.frame.width ?? 0,
                                        height: 1)
            self.signUpButton.titleLabel?.addBorder(.bottom, color: .colorBlack111111, thickness: 1)
        }
    }
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            self.loginButton.setTitle(StringConstants.s03BtnLogin.localized, for: .normal)
            self.loginButton.setTitle(StringConstants.s03BtnLogin.localized, for: .highlighted)
            self.loginButton.layer.cornerRadius = 6
            self.loginButton.titleLabel?.font = .font(with: .bold700, size: 16)
        }
    }
    @IBOutlet private weak var rememberLabel: UILabel! {
        didSet {
            self.rememberLabel.font = .font(with: .medium500, size: 12)
            self.rememberLabel.textColor = .colorBlack111111
            self.rememberLabel.text = StringConstants.s03RememberMe.localized
        }
    }
    @IBOutlet private weak var messageRegisterLabel: UILabel! {
        didSet {
            self.messageRegisterLabel.font = .font(with: .medium500, size: 12)
            self.messageRegisterLabel.textColor = .colorBlack111111
            self.messageRegisterLabel.text = StringConstants.s03LbRegister.localized
        }
    }
    @IBOutlet private weak var rememberPasswordButton: CheckBoxButton!
    @IBOutlet weak var registrationButton: UIButton! {
        didSet {
            self.registrationButton.setTitle(StringConstants.s03NewMember.localized, for: .normal)
            self.registrationButton.setTitle(StringConstants.s03NewMember.localized, for: .highlighted)
        }
    }
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.loginSuccess()
        self.loginFailure()
    }
    
}

// MARK: - Methods
extension LoginViewController {
    
    private func loginSuccess() {
        self.viewModel.loginSuccess = {
            CommonManager.hideLoading()
//            self.backHome()
//            NotificationCenter.default.post(name: NSNotification.favoriteChanged, object: true)
            DelegateManager.shared.setRootViewController(TabBarViewController(type: .home))
        }
    }
    
    private func loginFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            self.messageErrorLabel.text = error == MessageCode.E005.message ? "* " + MessageCode.E005Login.message : "* " + error
            self.handleFailure()
        }
    }
    
    private func backHome() {
        self.pop()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        
        if UserDefaultManager.isRemember ?? false {
            self.usernameTextField.text = KeychainManager.phoneNumber()
            self.passwordTextField.text = KeychainManager.password()
        }

        self.usernameTextField.customTextField.becomeFirstResponder()
        self.rememberPasswordButton.isChecked = UserDefaultManager.isRemember ?? false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.enableButton()
        CommonManager.hideLoading()
        CommonManager.hideTimeOut()
    }
    
    private func handleFailure() {
        self.usernameTextField.changeState(state: .error)
        self.passwordTextField.changeState(state: .error)
        self.messageErrorLabel.textColor = .colorRedEB2727
        self.messageErrorView.isHidden = false
        self.loginButton.isEnabled = false
        self.loginButton.backgroundColor = .colorE5E5E5
        self.loginButton.setTitleColor(.color646464, for: .normal)
    }
    
    private func enableButton() {
        let phoneNumber = self.usernameTextField.text ?? ""
        if phoneNumber.count <= Constants.PHONE_COUNT
            && phoneNumber != ""
            && self.passwordTextField.text != "" {
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = .colorYellowFFCC00
            self.loginButton.setTitleColor(.colorBlack111111, for: .normal)
        } else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = .colorE5E5E5
            self.loginButton.setTitleColor(.color646464, for: .normal)
        }
    }
    
}

// MARK: - Actions
extension LoginViewController {
    
    @IBAction private func login(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        CommonManager.showLoading()
        self.viewModel.login(username: username,
                             password: password,
                             isRemember: self.rememberPasswordButton.isChecked)
        
        UserDefaultManager.isRemember = self.rememberPasswordButton.isChecked
        self.view.endEditing(true)
    }
    
    @IBAction private func forgotPasswordAction(_ sender: Any) {
        self.push(viewController: ResetPasswordViewController())
    }
    
    @IBAction private func signUp(_ sender: Any) {
        self.push(viewController: SignUpViewController())
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func setLoginEnable() {
        self.enableButton()
    }
    
    @objc private func clearError(_ sender: UITextField) {
        self.messageErrorView.isHidden = true
        self.enableButton()
        if sender == self.usernameTextField.customTextField {
            self.passwordTextField.changeState(state: .normal)
        } else {
            self.usernameTextField.changeState(state: .normal)
        }
    }
    
}

// MARK: FloatingTextFieldDelegate
extension LoginViewController: FloatingTextFieldDelegate {
    
    func handleClearTextTextField() {
        self.loginButton.isEnabled = false
        self.loginButton.backgroundColor = .colorE5E5E5
        self.loginButton.setTitleColor(.color646464, for: .normal)
    }
    
}
