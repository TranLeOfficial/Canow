//
//  OTPVerifyViewController.swift
//  Canow
//
//  Created by PhuNT14 on 12/10/2021.
//
//  Screen ID: S01003

import UIKit

class OTPVerifyViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s01SMSAuthentication.localized, color: .colorBlack111111)
            self.headerView.bgColor = .colorYellowFFCC00
            self.headerView.backButtonHidden = false
            self.headerView.rightButtonHidden = true
            self.headerView.onBack = {
                self.navigationController?.viewControllers.forEach({ (vc) in
                    switch self.passwordType {
                    case .forgot:
                        if let resetPasswordViewController = vc as? ResetPasswordViewController {
                            self.popTo(viewController: resetPasswordViewController)
                        }
                    case .register:
                        if let setPasswordController = vc as? SetPasswordViewController {
                            self.popTo(viewController: setPasswordController)
                        }
                    }
                })
            }
        }
    }
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentView.backgroundColor = .white
        }
    }
    @IBOutlet private weak var messageErrorStackView: UIStackView!
    @IBOutlet private weak var bottomConstraintResentButton: NSLayoutConstraint!
    @IBOutlet private weak var errorLabel: UILabel! {
        didSet {
            self.errorLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var phoneLabel: UILabel! {
        didSet {
            self.phoneLabel.font = .font(with: .medium500, size: 14)
            self.phoneLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var OTPView: OTPView! {
        didSet {
            self.OTPView.delegate = self
        }
    }
    @IBOutlet private weak var resentLabel: UILabel! {
        didSet {
            self.resentLabel.font = .font(with: .bold700, size: 16)
            self.resentLabel.textColor = .color646464
            self.resentLabel.text = StringConstants.s01BtnResent.localized
        }
    }
    @IBOutlet private weak var resentView: UIView! {
        didSet {
            self.resentView.clipsToBounds = true
            self.resentView.backgroundColor = .colorE5E5E5
            self.resentView.layer.cornerRadius = 5
        }
    }
    @IBOutlet private weak var resendButton: UIButton! {
        didSet {
            self.resendButton.setTitleColor(.clear, for: .normal)
            self.resendButton.setTitleColor(.clear, for: .highlighted)
        }
    }
    
    // MARK: - Properties
    var passwordType: PasswordType = .register
    var phone: String = ""
    var password: String = ""
    private var timeRemaining: Int = 60
    private var timer: Timer!
    private let viewModel = OTPVerifyViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.verifyOTPFailure()
    }
    
}

// MARK: - Methods
extension OTPVerifyViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        self.phoneLabel.text = "\(StringConstants.s01LbEnterOtp.localized)\(phone)"
        if CommonManager.checkLanguageJP {
            self.phoneLabel.text = "\(phone) \(StringConstants.s01LbEnterOtp.localized)"
        }
        OTPView.focusOTPTextfield()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupData() {
        switch passwordType {
        case .register:
            self.viewModel.sendOTPRegister(phone: phone)
        case .forgot:
            self.viewModel.forgotPassword(phone)
        }
    }
    
    func reloadData() {
        self.viewModel.otpVerifySuccess = {
            CommonManager.hideLoading()
            self.viewModel.firstSetPassword(phone: self.phone, password: self.password)
        }
        
        self.viewModel.setPasswordSuccess = {
            self.messageErrorStackView.isHidden = true
            self.gotoSetUpdateProfile()
            CommonManager.hideLoading()
        }
        
        self.viewModel.confirmForgotPasswordSuccess = {
            CommonManager.hideLoading()
            self.push(viewController: ResetPasswordSuccessfull())
        }
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
        }
    }
    
    func verifyOTPFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            switch error {
            case MessageCode.E037.message:
                self.timer.invalidate()
                self.timeRemaining = 60
                self.resentLabel.text = StringConstants.s01BtnResent.localized
                self.countDownLock()
                self.showPopup(title: StringConstants.s01TitleOtpLock.localized,
                               message: StringConstants.s01MessageOtpLock.localized,
                               popupBg: UIImage(named: "bg_lock"),
                               rightButton: (title: StringConstants.s01BtnBack.localized, action: {
                    self.dismiss(animated: true)
                    self.navigationController?.viewControllers.forEach({ (vc) in
                        switch self.passwordType {
                        case .forgot:
                            if let resetPasswordViewController = vc as? ResetPasswordViewController {
                                self.popTo(viewController: resetPasswordViewController)
                            }
                        case .register:
                            if let signUpViewController = vc as? SignUpViewController {
                                self.popTo(viewController: signUpViewController)
                            }
                        }
                    })
                }))
            default:
                self.messageErrorStackView.isHidden = false
                self.errorLabel.text = error
                self.OTPView.borderColor = .colorRedEB2727
            }
        }
    }
    
    private func gotoSetUpdateProfile() {
        let view = UpdateProfileViewController()
        view.phone = self.phone
        if let userDataInfo = self.viewModel.userDataInfo {
            view.userDataInfo = userDataInfo
        }
        self.push(viewController: view)
    }
    
    private func countDownLock() {
        self.resendButton.isUserInteractionEnabled = false
        self.resentLabel.textColor = .color646464
        self.resentView.backgroundColor = .colorE5E5E5
        var min = 60
        var s = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if s > 0 {
                s -= 1
            }
            if min > 0 && s == 0 {
                min -= 1
                s = 60
            }
            if min == 0 && s == 0 {
                timer.invalidate()
                self.resentView.backgroundColor = .colorYellowFFCC00
                self.resentLabel.textColor = .colorBlack111111
                self.resendButton.isUserInteractionEnabled = true
                return
            }
        })
    }
    
}

// MARK: - Actions
extension OTPVerifyViewController {
    
    @IBAction func resendOTP(_ sender: Any) {
        switch passwordType {
        case .register:
            self.viewModel.resendOTP(phone: phone)
        case .forgot:
            self.viewModel.resendOTPForgot(phone)
        }
        self.resentLabel.textColor = .color646464
        self.resentView.backgroundColor = .colorE5E5E5
        self.resendButton.isUserInteractionEnabled = false
        self.timeRemaining = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    @IBAction func focusOTP(_ sender: Any) {
        self.messageErrorStackView.isHidden = true
        OTPView.focusOTPTextfield()
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            self.bottomConstraintResentButton.constant = isKeyboardShowing ? keyboardFrame.height + 14 : 50
            if !isKeyboardShowing {
                self.OTPView.clearFocus()
            }
        }
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            self.resentLabel.text = "\(StringConstants.s01BtnResent.localized) (00:\(timeRemaining))"
            timeRemaining -= 1
        } else {
            timer.invalidate()
            self.resentLabel.text = StringConstants.s01BtnResent.localized
            self.resentView.backgroundColor = .colorYellowFFCC00
            self.resentLabel.textColor = .colorBlack111111
            self.resendButton.isUserInteractionEnabled = true
        }
    }
    
}

// MARK: - verify OTP
extension OTPVerifyViewController: OTPViewDelegate {
    
    func verifyOTP() {
        if let otp = OTPView.getOTP() {
            switch passwordType {
            case .register:
                self.viewModel.verifyOTP(phone: phone, otp: otp)
            case .forgot:
                self.viewModel.setPassword(otp: otp, username: phone, password: password)
            }
        }
    }
    
}
