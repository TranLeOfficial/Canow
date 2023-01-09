//
//  TransferFanTokenViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/22/21.
//

import UIKit
import Kingfisher

enum TransferType: CaseIterable {
    case transferFantoken
    case transferStableToken
}

class TransferFanTokenViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.transfer.localized)
            self.headerView.rightButtonImage = UIImage(named: "ic_QRCode")
            self.headerView.rightButtonHidden = false
            self.headerView.onBack = {
                self.pop()
            }
            self.headerView.onPressRightButton = {
                self.openCamera(checkPermissionOnly: true) { _ in
                    let scanQRViewController = ScanQRViewController()
                    scanQRViewController.delegate = self
                    scanQRViewController.transactionType = .transfer
                    scanQRViewController.modalPresentationStyle = .overFullScreen
                    self.present(viewController: scanQRViewController)
                }
            }
        }
    }
    
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            self.backgroundView.backgroundColor = .white
            self.backgroundView.layer.cornerRadius = 20
            self.backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet private weak var textFieldView: UIView! {
        didSet {
            self.textFieldView.layer.cornerRadius = 6
            self.textFieldView.layer.borderWidth = 1
            self.textFieldView.layer.borderColor = UIColor.colorE5E5E5.cgColor
        }
    }
    @IBOutlet private weak var phoneNumberTextField: UITextField! {
        didSet {
            self.phoneNumberTextField.becomeFirstResponder()
            self.phoneNumberTextField.tintColor = .colorBlack111111
            self.phoneNumberTextField.keyboardType = .numberPad
            self.phoneNumberTextField.placeholder = StringConstants.s05PhonePlaceholder.localized
            self.phoneNumberTextField.delegate = self
            self.phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet private weak var contactResultTableView: UITableView! {
        didSet {
            self.contactResultTableView.delegate = self
            self.contactResultTableView.dataSource = self
            self.contactResultTableView.registerReusedCell(cellNib: ContactResultCell.self)
            self.contactResultTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        }
    }
    @IBOutlet weak var findContactErrorLabel: UILabel! {
        didSet {
            self.findContactErrorLabel.text = StringConstants.s05MessageCantFindContact.localized
        }
    }
    
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var notFoundView: UIView!
    
    // MARK: - Properties
    private let viewModel = TransferFanTokenViewModel()
    var transferType: TransferType = .transferStableToken
    var fanTokenBalance: Int = 0
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension TransferFanTokenViewController {
    
    private func reloadData() {
        self.viewModel.fetchDataReceiver = {
            CommonManager.hideLoading()
            self.contactResultTableView.reloadData()
            self.notFoundView.isHidden = !self.viewModel.receiverTransferInfo.isEmpty
            self.contactResultTableView.isHidden = self.viewModel.receiverTransferInfo.isEmpty
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
    }
    
}

// MARK: - Actions
extension TransferFanTokenViewController {
    
    @IBAction func didTapClearButton(_ sender: UIButton) {
        self.phoneNumberTextField.text = ""
        self.contactResultTableView.isHidden = true
        self.notFoundView.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func scanQRPhoneNumber(_ sender: UITapGestureRecognizer) {
        self.openCamera(checkPermissionOnly: true) { _ in
            let scanQRVC = ScanQRViewController()
            scanQRVC.delegate = self
            scanQRVC.transactionType = .transfer
            scanQRVC.modalPresentationStyle = .overFullScreen
            self.present(viewController: scanQRVC)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension TransferFanTokenViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldView.layer.borderColor = UIColor.colorBlack111111.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= Constants.PHONE_COUNT
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        if !text.isEmpty {
            self.clearButton.isHidden = false
            self.textFieldView.layer.borderColor = UIColor.colorBlack111111.cgColor
            if text.count == Constants.PHONE_COUNT {
                self.viewModel.getListReceiver(phoneNumber: text)
            } else {
                self.contactResultTableView.isHidden = true
                self.notFoundView.isHidden = true
            }
        } else {
            self.clearButton.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldView.layer.borderColor = UIColor.colorE5E5E5.cgColor
    }
    
}

// MARK: - ScanQRResultDelegate
extension TransferFanTokenViewController: ScanQRDelegate {
    
    func scanResult<T>(model: T) {
        guard let phone = model as? String else {
            return
        }
        self.phoneNumberTextField.text = phone
        self.viewModel.getListReceiver(phoneNumber: phone)
    }
    
}

// MARK: - UITableViewDelegate
extension TransferFanTokenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inputAmountTransactionViewController = InputAmountTransactionViewController(transactionType: .transfer)
        inputAmountTransactionViewController.transferType = self.transferType
        if let fanTokenInfo = DataManager.shared.getMerchantInfo() {
            inputAmountTransactionViewController.fanTokenLogo = fanTokenInfo.fantokenLogo ?? ""
            inputAmountTransactionViewController.fanTokenTicker = fanTokenInfo.fantokenTicker
            inputAmountTransactionViewController.fanTokenBalance = self.fanTokenBalance
        }
        let receiver = self.viewModel.receiverTransferInfo[indexPath.row]
        if receiver.status == "Active" {
            DataManager.shared.saveReceiverInfo(receiver)
            self.push(viewController: inputAmountTransactionViewController)
        } else {
            return
        }
    }
    
}

// MARK: - UITableViewDataSource
extension TransferFanTokenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.receiverTransferInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: ContactResultCell.self)
        cell?.configure(data: self.viewModel.receiverTransferInfo[indexPath.row])
        cell?.updateUI(data: self.viewModel.receiverTransferInfo[indexPath.row])
        return cell ?? BaseTableViewCell()
    }
    
}

// MARK: - Handle UITextFieldDidChanged
extension TransferFanTokenViewController {
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if !text.isEmpty {
            self.clearButton.isHidden = false
            self.textFieldView.layer.borderColor = UIColor.colorBlack111111.cgColor
            if text.count == Constants.PHONE_COUNT {
                self.viewModel.getListReceiver(phoneNumber: text)
            } else {
                self.contactResultTableView.isHidden = true
                self.notFoundView.isHidden = true
            }
        } else {
            self.clearButton.isHidden = true
        }
    }
}
