//
//  InputAmountViewController.swift
//  Canow
//
//  Created by NhanTT13 on 11/19/21.
//

import UIKit

class InputAmountViewController: BaseViewController {

    // MARK: - Outlet
    @IBOutlet weak var yellImage: UIImageView! {
        didSet {
            self.yellImage.layer.cornerRadius = self.yellImage.frame.size.width / 2
        }
    }
    @IBOutlet weak var partnerImage: UIImageView! {
        didSet {
            self.partnerImage.layer.cornerRadius = self.partnerImage.frame.size.width / 2
        }
    }
    @IBOutlet weak var amountYellTextField: UITextField! {
        didSet {
            self.amountYellTextField.delegate = self
        }
    }
    @IBOutlet weak var amountPartnerTextField: UITextField! {
        didSet {
        }
    }
    @IBOutlet weak var yellNameLabel: UILabel! {
        didSet {
        }
    }
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var messageErrorLabel: UILabel!
    @IBOutlet weak var goTopUpNowLabel: UILabel! {
        didSet {
            self.goTopUpNowLabel.underline()
            self.goTopUpNowLabel.text = StringConstants.topUpNow
        }
    }
    @IBOutlet weak var exchangeButton: UIButton! {
        didSet {
            self.exchangeButton.setTitle(StringConstants.exchangeNow, for: .normal)
            self.exchangeButton.layer.cornerRadius = 10
            self.exchangeButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.exchangeButton.isUserInteractionEnabled = false
            self.exchangeButton.backgroundColor = .lightGray
        }
    }
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.exchange.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    
    // MARK: - Properties
    var viewModel = InputAmountViewModel()
    var tokenName: String = ""
    var partnerId: Int = 0
    var urlImagePartner: String = ""
    var fanTokenBalanceTeamSelect: Int = 0
    var walletBalance: Int = 0
    var exchangeAmount: Int = 0
    var teamFantokenTicker: String = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fetchData()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupBackgroundTouch()
    }

    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        self.getData()
    }
}

// MARK: - Methods
extension InputAmountViewController {
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topUpNow))
        self.goTopUpNowLabel.isUserInteractionEnabled = true
        self.goTopUpNowLabel.addGestureRecognizer(tapGesture)
    }
    
    private func getData() {
        self.viewModel.fetchCustomerInfoSuccess = { customerInfo in
            let urlImage = customerInfo.avatar ?? ""
            if let url = URL(string: NetworkManager.shared.baseURLImage + urlImage) {
                self.yellImage.kf.setImage(with: url)
            }
            if let wallet = customerInfo.listWallet.filter({ $0.tokenType == "YELL" }).first {
                UserDefaultManager.tokenName = wallet.tokenName
                self.yellNameLabel.text = wallet.tokenName
                self.walletBalance = wallet.balance
            }
            
        }
        self.partnerNameLabel.text = tokenName
        if let url = URL(string: NetworkManager.shared.baseURLImage + urlImagePartner) {
            self.partnerImage.kf.setImage(with: url)
        }
        self.teamFantokenTicker = tokenName
    }
    
    private func transactionStatus() {
        self.viewModel.fetchDataSuccess = { transactionId in
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.transactionType = .exchange
            viewController.teamFantokenTickerExchange = self.teamFantokenTicker
            self.push(viewController: viewController)
        }
    }
}

// MARK: - Actions
extension InputAmountViewController {
    @IBAction func exchangeActionButton(_ sender: UIButton) {
        guard let inputAmountExchange = self.amountYellTextField.text else { return }
        guard let amount = Int(inputAmountExchange) else { return }
        self.exchangeAmount = amount
        let alertVC = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: StringConstants.ok, style: .default) { _ in
            if amount > self.walletBalance {
                self.messageErrorLabel.isHidden = false
                self.messageErrorLabel.text = "Your balance is \(self.walletBalance)"
                self.goTopUpNowLabel.isHidden = false
            } else if amount > self.fanTokenBalanceTeamSelect {
                self.messageErrorLabel.isHidden = false
                self.messageErrorLabel.text = MessageCode.E028.message
                self.goTopUpNowLabel.isHidden = true
            } else {
                self.viewModel.amountExchange(partnerId: self.partnerId, amount: amount)
                self.transactionStatus()
            }
        }
        guard let image = UIImage(named: "ic_confirm") else { return }
        alertVC.addImage(image: image)
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func topUpNow(sender: UITapGestureRecognizer) {
        self.push(viewController: TopupViewController())
    }
}

// MARK: - TextField Delegate
extension InputAmountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if !text.isEmpty && Int(text) != 0 {
            self.exchangeButton?.isUserInteractionEnabled = true
            self.exchangeButton?.backgroundColor = .purple
            self.amountPartnerTextField?.text = text
        } else {
            self.exchangeButton?.isUserInteractionEnabled = false
            self.exchangeButton?.backgroundColor = .lightGray
            self.amountPartnerTextField?.text = ""
        }
        
        return true
    }
}

// MARK: - Dismiss Keyboard Touch
extension InputAmountViewController {
    
    private func setupBackgroundTouch() {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTap() {
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
}
