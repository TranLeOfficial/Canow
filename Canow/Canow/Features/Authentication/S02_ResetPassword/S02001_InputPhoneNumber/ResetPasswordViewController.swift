//
//  ResetPasswordViewController.swift
//  Canow
//
//  Created by NhanTT13 on 10/22/21.
//

import UIKit

class ResetPasswordViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.backButtonHidden = false
            self.headerView.rightButtonHidden = true
            self.headerView.bgColor = .colorYellowFFCC00
            self.headerView.setTitle(title: StringConstants.s02TitleHeader.localized, color: .colorBlack111111)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var ressetPasswordImageView: UIImageView!
    @IBOutlet private weak var phoneNumberTextField: FloatingLabelTextField! {
        didSet {
            self.phoneNumberTextField.cornerRadius = 8
            self.phoneNumberTextField.placeholder = StringConstants.s02PhonePlaceHolder.localized
            self.phoneNumberTextField.type = .normal
            self.phoneNumberTextField.textCount = Constants.PHONE_COUNT
            self.phoneNumberTextField.keyboardType = .numberPad
            self.phoneNumberTextField.didBeginEditing = {
                self.messageErrorLabel.isHidden = true
            }
            self.phoneNumberTextField.customTextField.addTarget(self,
                                                                action: #selector(self.setNextActionEnable),
                                                                for: .editingChanged)
            self.phoneNumberTextField.delegate = self
        }
    }
    
    @IBOutlet private weak var nextButton: UIButton! {
        didSet {
            self.nextButton.setTitle(StringConstants.s02BtnNext.localized, for: .normal)
            self.nextButton.setTitle(StringConstants.s02BtnNext.localized, for: .highlighted)
            self.nextButton.layer.cornerRadius = 6
            self.nextButton.tintColor = .color646464
            self.nextButton.backgroundColor = .colorE5E5E5
            self.nextButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.nextButton.isUserInteractionEnabled = false
        }
    }
    @IBOutlet private weak var messageErrorLabel: UILabel! {
        didSet {
            self.messageErrorLabel.font = .font(with: .medium500, size: 12)
            self.messageErrorLabel.textColor = .colorRedEB2727
        }
    }
    @IBOutlet private weak var phoneNumberRequestLabel: UILabel! {
        didSet {
            self.phoneNumberRequestLabel.font = .font(with: .regular400, size: 14)
            self.phoneNumberRequestLabel.textColor = .colorBlack111111
            self.phoneNumberRequestLabel.text = StringConstants.s02LbMessage.localized
        }
    }
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var nextButtonConstraintBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    private let viewModel = ResetPasswordViewModel()
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func bindViewAndViewModel() {
        self.reloadData()
        self.showError()
    }
    
}

// MARK: - Methods
extension ResetPasswordViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        self.phoneNumberTextField.customTextField.becomeFirstResponder()
        self.setupBackgroundTouch()
        self.enableButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func reloadData() {
        self.viewModel.checkAccountExistedSuccess = {
            CommonManager.hideLoading()
            let setNewPasswordViewController = SetPasswordViewController()
            setNewPasswordViewController.phone = self.phoneNumberTextField.customTextField.text
            setNewPasswordViewController.passwordType = .forgot
            self.push(viewController: setNewPasswordViewController)
        }
    }
    
    private func showError() {
        self.viewModel.checkAccountExistedFailure = { error in
            CommonManager.hideLoading()
            self.messageErrorLabel.text = error == MessageCode.E005.message ? "* " + MessageCode.E005Reset.message : "* " + error
            self.messageErrorLabel.isHidden = false
            self.phoneNumberTextField.changeState(state: .error)
        }
    }
    
    private func enableButton() {
        let phoneNumber = self.phoneNumberTextField.text ?? ""
        if phoneNumber.count <= Constants.PHONE_COUNT && phoneNumber != "" {
            self.nextButton.setTitleColor(.colorBlack111111, for: .normal)
            self.nextButton.backgroundColor = .colorYellowFFCC00
            self.nextButton.isUserInteractionEnabled = true
        } else {
            self.nextButton.setTitleColor(.color646464, for: .normal)
            self.nextButton.backgroundColor = .colorE5E5E5
            self.nextButton.isUserInteractionEnabled = false
        }
    }
    
    private func handleFailure() {
        self.phoneNumberTextField.changeState(state: .error)
        self.messageErrorLabel.isHidden = false
    }
    
}

// MARK: - IBActions
extension ResetPasswordViewController {
    
    @IBAction func nextAction(_ sender: UIButton!) {
        if let phoneNumber = self.phoneNumberTextField.text {
            self.phoneNumberTextField.customTextField.resignFirstResponder()
            if !self.viewModel.validatePhoneNumber(phone: phoneNumber) {
                self.handleFailure()
                self.messageErrorLabel.text = "* \(StringConstants.s01MessagePhoneError.localized)"
                return
            }
            self.viewModel.checkAccountExist(phone: phoneNumber)
        } else {
            print("Error!")
        }
    }
    
}

// MARK: - Keyboard Helpers
extension ResetPasswordViewController {
    
    private func setupBackgroundTouch() {
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func setNextActionEnable() {
        self.enableButton()
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.nextButtonConstraintBottom.constant = isKeyboardShowing ? keyboardFrame.height + 16 : 16
                DispatchQueue.main.async {
                    isKeyboardShowing ? self.scrollView.scrollToBottom() : self.scrollView.scrollToTop()
                }
                self.view.layoutIfNeeded()
            })
        }
    }
    
}

extension ResetPasswordViewController: FloatingTextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.enableButton()
    }
    
}
