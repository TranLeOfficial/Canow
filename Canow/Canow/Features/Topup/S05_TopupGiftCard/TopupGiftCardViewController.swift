//
//  TopupGiftCardViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//
//  Screen ID: S05001

import UIKit

class TopupGiftCardViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s04GiftCard.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    
    @IBOutlet weak var inputViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftCardImage: UIImageView!
    @IBOutlet private weak var giftCardCodeTextField: FloatingLabelTextField! {
        didSet {
            self.giftCardCodeTextField.placeholder = StringConstants.s04ValueCardCode.localized
            self.giftCardCodeTextField.type = .giftCode
            self.giftCardCodeTextField.textCount = 21
            self.giftCardCodeTextField.keyboardType = .default
            self.giftCardCodeTextField.delegate = self
            self.giftCardCodeTextField.onShouldReturn = {
                self.view.endEditing(true)
            }
        }
    }
    
    @IBOutlet private weak var messageErrorView: UIView!
    
    @IBOutlet private weak var messageErrorLabel: UILabel!
    
    @IBOutlet private weak var giftCardValueTextField: FloatingLabelTextField! {
        didSet {
            self.giftCardValueTextField.placeholder = StringConstants.s04ValueGiftCard.localized
            self.giftCardValueTextField.type = .normal
            self.giftCardValueTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet private weak var redeemButton: CustomButton! {
        didSet {
            self.redeemButton.layer.cornerRadius = 6
            self.redeemButton.setTitle(StringConstants.s04Redeem.localized, for: .normal)
            self.redeemButton.setTitle(StringConstants.s04Redeem.localized, for: .highlighted)
            self.redeemButton.disable()
        }
    }
    
    @IBOutlet private weak var redeemButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            self.backgroundView.backgroundColor = .white
            self.backgroundView.layer.cornerRadius = 20
            self.backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var stableTokenImage: UIImageView!
    
    // MARK: - Properties
    private let viewModel = TopupGiftCardViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableButtonRedeem(false)
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension TopupGiftCardViewController {
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = { transactionId in
            CommonManager.hideLoading()
            self.giftCardCodeTextField.text = ""
            self.giftCardValueTextField.text = ""
            let transactionStatusViewController = TransactionStatusViewController()
            transactionStatusViewController.transactionType = .topUp
            transactionStatusViewController.topUpType = .giftCard
            transactionStatusViewController.transactionId = transactionId
            self.push(viewController: transactionStatusViewController)
        }
        self.viewModel.fetchGiftCardInfoSuccess = { giftCardInfo in
            CommonManager.hideLoading()
            self.giftCardValueTextField.text = "\(giftCardInfo.amount ?? 0)".formatPrice()
            self.enableButtonRedeem(true)
        }
        
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            if error == MessageCode.E028.message {
                self.messageErrorLabel.text = StringConstants.S04MessageErrorE028.localized
            } else {
                self.messageErrorLabel.text = "* " + error
            }
            self.handleFailure()
        }
    }
    
    private func setupUI() {
        self.giftCardCodeTextField.customTextField.becomeFirstResponder()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.view.backgroundColor = .colorYellowFFCC00
    }
    
    private func handleFailure() {
        self.messageErrorView.isHidden = false
        self.giftCardCodeTextField.changeState(state: .error)
        self.enableButtonRedeem(false)
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.giftCardImage.isHidden = isKeyboardShowing
                self.inputViewTopConstraint.constant = isKeyboardShowing ? (self.giftCardImage.frame.height + 15) * -1 : 30
                self.redeemButtonBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height + 14 : 50
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func enableButtonRedeem(_ isEnable: Bool) {
        if isEnable {
            self.redeemButton.enable()
        } else {
            self.redeemButton.disable()
        }
    }
    
    private func isValidGiftCard(_ giftCardId: String) -> Bool {
        let giftCode = NSPredicate(format: "SELF MATCHES %@", Regex.giftCard.rawValue)
        return giftCode.evaluate(with: giftCardId)
    }
    
}

// MARK: - Actions
extension TopupGiftCardViewController {
    
    @IBAction func redeemGiftCard(_ sender: UIButton) {
        guard let giftCardId = self.giftCardCodeTextField.customTextField.text else {
            return
        }
        let giftCardID = giftCardId.replacingOccurrences(of: " ", with: "")
        self.viewModel.topupGiftCard(giftcardId: giftCardID)
    }
    
}

// MARK: - FloatingTextFieldDelegate
extension TopupGiftCardViewController: FloatingTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        self.giftCardCodeTextField.changeState(state: .editting)
        self.messageErrorView.isHidden = true
        if text.count < 21 {
            self.giftCardValueTextField.text = ""
            self.enableButtonRedeem(false)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.count == 21 {
            let giftCardId = text.replacingOccurrences(of: " ", with: "")
            self.viewModel.getGiftCardInfo(giftcardId: giftCardId)
        }
    }
    
    func handleClearTextTextField() {
        self.giftCardValueTextField.text = ""
        self.enableButtonRedeem(false)
    }
    
}
