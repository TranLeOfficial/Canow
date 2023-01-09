//
//  InputAmountTransactionViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/26/21.
//

import UIKit

class InputAmountTransactionViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.bgColor = .clear
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet private weak var yellLabel: UILabel! {
        didSet {
            self.yellLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            self.backgroundView.clipsToBounds = true
            self.backgroundView.layer.cornerRadius = 20
            self.backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 16)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var amountTextField: UITextField! {
        didSet {
            self.amountTextField.text = "0"
            self.amountTextField.becomeFirstResponder()
            self.amountTextField.keyboardType = .numberPad
            self.amountTextField.textColor = .colorBlack111111
            self.amountTextField.font = .font(with: .bold700, size: 40)
            UITextField.appearance().tintColor = .colorBlack111111
            self.amountTextField.delegate = self
            self.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet private weak var exceededView: UIView!
    @IBOutlet private weak var swapTokenView: UIView!
    @IBOutlet private weak var balanceView: UIView! {
        didSet {
            self.balanceView.clipsToBounds = true
            self.balanceView.backgroundColor = .colorE5E5E580
            self.balanceView.layer.cornerRadius = self.balanceView.frame.height / 2
        }
    }
    @IBOutlet private weak var exceededLabel: UILabel! {
        didSet {
            self.exceededLabel.font = .font(with: .medium500, size: 12)
            self.exceededLabel.text = StringConstants.s04MessageErrorE038.localized
            self.exceededLabel.textColor = .colorRedEB2727
        }
    }
    @IBOutlet private weak var exceededCoinLabel: UILabel! {
        didSet {
            self.exceededCoinLabel.font = .font(with: .medium500, size: 12)
            self.exceededCoinLabel.textColor = .colorRedEB2727
        }
    }
    @IBOutlet private weak var exceededCoin1Label: UILabel! {
        didSet {
            self.exceededCoin1Label.font = .font(with: .medium500, size: 12)
            self.exceededCoin1Label.textColor = .colorRedEB2727
        }
    }
    @IBOutlet private weak var firstButton: UIButton! {
        didSet {
            self.firstButton.layer.cornerRadius = 6
            self.firstButton.titleLabel?.font = .font(with: .bold700, size: 15)
            self.firstButton.tintColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var secondButton: CustomButton! {
        didSet {
            self.secondButton.layer.cornerRadius = 6
            self.secondButton.titleLabel?.font = .font(with: .bold700, size: 15)
            self.secondButton.disable()
        }
    }
    @IBOutlet private weak var errorLabel: UILabel! {
        didSet {
            self.errorLabel.font = .font(with: .medium500, size: 12)
            self.errorLabel.isHidden = true
        }
    }
    @IBOutlet private weak var errorLabel1: UILabel! {
        didSet {
            self.errorLabel1.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var transactionLimitStackView: UIStackView!
    @IBOutlet private weak var transactionLimit2StackView: UIStackView!
    @IBOutlet private weak var recommendAmount1: UIButton! {
        didSet {
            self.recommendAmount1.titleLabel?.font = .font(with: .medium500, size: 14)
            self.recommendAmount1.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
        }
    }
    @IBOutlet private weak var recommendAmount2: UIButton! {
        didSet {
            self.recommendAmount2.titleLabel?.font = .font(with: .medium500, size: 14)
            self.recommendAmount2.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
        }
    }
    @IBOutlet private weak var recommendAmount3: UIButton! {
        didSet {
            self.recommendAmount3.titleLabel?.font = .font(with: .medium500, size: 14)
            self.recommendAmount3.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
        }
    }
    @IBOutlet private weak var recommendAmount4: UIButton! {
        didSet {
            self.recommendAmount4.titleLabel?.font = .font(with: .medium500, size: 14)
            self.recommendAmount4.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
        }
    }
    @IBOutlet private weak var heightHeaderView: NSLayoutConstraint!
    @IBOutlet private weak var topupButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackButtonRecommend: UIStackView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var stableTokenImage: UIImageView! {
        didSet {
            self.stableTokenImage.rounded()
        }
    }
    @IBOutlet weak var exchangeStableTokenView: UIView!
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var equalSignLabel: UILabel! {
        didSet {
            self.equalSignLabel.font = .font(with: .medium500, size: 14)
            self.equalSignLabel.text = "="
        }
    }
    @IBOutlet weak var exchangeStableTokenImage: UIImageView! {
        didSet {
            self.exchangeStableTokenImage.rounded()
        }
    }
    @IBOutlet weak var exchangeEqualAmoutLabel: UILabel!
    @IBOutlet weak var iconStableTokenImage: UIImageView! {
        didSet {
            self.iconStableTokenImage.rounded()
        }
    }
    @IBOutlet weak var iconStableTokenImage1: UIImageView! {
        didSet {
            self.iconStableTokenImage1.rounded()
        }
    }
    @IBOutlet private weak var prefixLabel: UILabel! {
        didSet {
            self.prefixLabel.font = .font(with: .medium500, size: 12)
            self.prefixLabel.textColor = .colorRedEB2727
        }
    }
    
    // MARK: - Properties
    private let viewModel = InputAmountTransactionViewModel()
    private var externalLink: String = ""
    private lazy var amountButtonGroup: [UIButton] = {
        let amountButtonGroup: [UIButton] = [self.recommendAmount1, self.recommendAmount2,
                                             self.recommendAmount3, self.recommendAmount4]
        amountButtonGroup.forEach {
            $0.titleLabel?.font = .font(with: .medium500, size: 14)
            $0.setTitleColor(.colorB8B8B8, for: .normal)
            $0.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 6)
        }
        return amountButtonGroup
    }()
    private var outputAmounts: [String] = ["1000", "2000", "5000", "10000"]
    private var transactionType: TransactionType = .topUp
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    var payType: PayType = .payDiscountCoupon
    var transferType: TransferType = .transferStableToken
    var merchantInfo: QRPayByST?
    var payBalance: Int = 0
    var fanTokenTicker: String = ""
    var fanTokenLogo: String = ""
    var fanTokenBalance: Int = 0
    var urlImageLogoFantoken: String = ""
    var partnerId: Int = 0
    
    // Exchange
    var exchangeAmount: Int = 0
    var imageSTExchange: String = ""
    var balanceUserExchange: Int = 0
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.viewModel.fetchData()
    }
    
    // MARK: - Constructors
    init(transactionType: TransactionType) {
        self.transactionType = transactionType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension InputAmountTransactionViewController {
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = { topupCardInfo in
            CommonManager.hideLoading()
            self.externalLink = topupCardInfo.externalLink ?? ""
            let viewController = InformGMOViewController()
            viewController.delegate = self
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController: viewController)
        }
        
//        self.viewModel.fetchDataExchangeCustomerSuccess = { stableTokenCustomer in
//            self.payBalance = (stableTokenCustomer.balance ?? 0)
//            self.balanceLabel.text = "\(stableTokenCustomer.balance ?? 0)".formatPrice()
//        }
        
        self.viewModel.fetchCustomerInfoSuccess = { _ in
            if let merchantInfo = self.merchantInfo {
                self.viewModel.getTeamInfoSelected(partnerId: merchantInfo.partnerId)
//                self.yellLabel.text = merchantInfo.walletId
                CommonManager.showLoading()
            }
        }
        
        self.viewModel.getPartnerInfSuccess = {
            if let teamSelected = self.viewModel.teamSelected {
                self.headerView.setTitle(title: "\(StringConstants.s06TitlePay.localized) \(teamSelected.name)")
                DataManager.shared.saveMerchantInfo(teamSelected)
            }
            CommonManager.hideLoading()
        }
        
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            self.secondButton.disable()
            self.errorLabel.text = "* \(error)"
            self.errorLabel.isHidden = false
        }
        
        self.viewModel.inputAmountPayBySTFailure = { error in
            self.showAlert(title: "Error", message: error.debugDescription, actions: ("OK", {}))
            CommonManager.hideLoading()
        }
        
        self.viewModel.getPartnerInfFailure = { error in
            self.showAlert(title: "Error", message: error.debugDescription, actions: ("OK", {}))
            CommonManager.hideLoading()
        }
        
        self.viewModel.topUpFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            self.secondButton.disable()
            switch error {
            case MessageCode.E038.message:
                self.exceededView.isHidden = false
            case MessageCode.E028.message:
                self.errorLabel1.text = StringConstants.S04MessageErrorE028.localized
                self.errorLabel1.isHidden = false
            default :
                self.errorLabel1.text = "* \(error)"
                self.errorLabel1.isHidden = false
            }
        }
    }
    
    private func setupUI() {
        self.mapReccommnedAmount(amounts: self.outputAmounts)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        
        switch self.transactionType {
        case .topUp:
            self.setupTopUp()
        case .pay:
            self.setupPay()
        case .transfer:
            self.setupTransfer()
        case .exchange:
            self.setupExchange()
        default:
            break
        }
        self.viewModel.getStableTokenCustomerExchange()
        if CommonManager.checkLanguageJP {
            self.transactionLimitStackView.isHidden = false
            self.transactionLimit2StackView.isHidden = true
        }
    }
    
    private func setupExchange() {
        self.viewModel.fetchDataExchangeCustomerSuccess = { stableTokenCustomer in
            self.balanceLabel.text = "\(stableTokenCustomer.balance ?? 0)".formatPrice()
            self.payBalance = stableTokenCustomer.balance ?? 0
        }
        self.headerView.setTitle(title: StringConstants.s05BtnExchange.localized)
        self.balanceView.isHidden = false
        self.exchangeView.isHidden = false
        self.balanceLabel.textColor = .colorBlack111111
        self.firstButton.setTitle(StringConstants.s06ExchangeTopUp.localized, for: .normal)
        self.firstButton.setTitle(StringConstants.s06ExchangeTopUp.localized, for: .highlighted)
        self.secondButton.setTitle(StringConstants.s05BtnExchange.localized, for: .normal)
        self.secondButton.setTitle(StringConstants.s05BtnExchange.localized, for: .highlighted)
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            self.yellLabel.text = stableToken.name
            self.imageSTExchange = stableToken.logo
            UserDefaultManager.tokenName = stableToken.name
        }
        self.exchangeStableTokenImage.kf.setImage(with: CommonManager.getImageURL(self.urlImageLogoFantoken))
    }
    
    private func setupPay() {
        self.errorLabel.isHidden = true
        self.viewModel.fetchDataExchangeCustomerSuccess = { stableTokenCustomer in
            self.payBalance = (stableTokenCustomer.balance ?? 0)
            self.balanceLabel.text = "\(stableTokenCustomer.balance ?? 0)".formatPrice()
        }
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            self.yellLabel.text = stableToken.name
            UserDefaultManager.tokenName = stableToken.name
        }
        self.firstButton.setTitle(StringConstants.s05BtnTopup.localized, for: .normal)
        self.firstButton.setTitle(StringConstants.s05BtnTopup.localized, for: .highlighted)
        self.secondButton.setTitle(StringConstants.s06BtnPay.localized, for: .normal)
        self.secondButton.setTitle(StringConstants.s06BtnPay.localized, for: .highlighted)
        self.balanceView.isHidden = false
        self.swapTokenView.isHidden = true
        switch self.payType {
        case .payWithoutCoupon:
            self.headerView.isHidden = true
            self.backgroundView.layer.cornerRadius = 0
            self.heightHeaderView.constant = 0
//            self.yellLabel.text = self.merchantInfo?.walletId
            self.viewModel.getStableTokenCustomer()
        case .payPremoney:
            self.amountTextField.text = "\(self.merchantInfo?.amount ?? 0)".formatPrice()
            self.stackButtonRecommend.isHidden = true
            self.amountTextField.isUserInteractionEnabled = false
            self.secondButton.setTitle(StringConstants.s06BtnPay.localized, for: .normal)
            self.secondButton.setTitle(StringConstants.s06BtnPay.localized, for: .highlighted)
            self.secondButton.enable()
            self.errorLabel.text = StringConstants.s05LbPleaseExchange.localized
        default:
            self.amountTextField.text = "\(self.merchantInfo?.amount ?? 0)".formatPrice()
            self.stackButtonRecommend.isHidden = true
            self.amountTextField.isUserInteractionEnabled = false
            self.secondButton.setTitle(StringConstants.s06BtnPay.localized, for: .normal)
            self.secondButton.setTitle(StringConstants.s06BtnPay.localized, for: .highlighted)
            self.secondButton.enable()
        }
    }
    
    private func setupTransfer() {
        switch self.transferType {
        case .transferStableToken:
            self.firstButton.setTitle(StringConstants.s05BtnTopup.localized, for: .normal)
            self.firstButton.setTitle(StringConstants.s05BtnTopup.localized, for: .highlighted)
            self.viewModel.fetchDataExchangeCustomerSuccess = { stableTokenCustomer in
                self.balanceLabel.text = "\(stableTokenCustomer.balance ?? 0)".formatPrice()
            }
            self.viewModel.getStableTokenCustomer()
            if let stableToken = DataManager.shared.getStableTokenCustomer() {
                self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                self.yellLabel.text = stableToken.name
            }
        case .transferFantoken:
            self.firstButton.setTitle(StringConstants.s07BtnExchange.localized, for: .normal)
            self.firstButton.setTitle(StringConstants.s07BtnExchange.localized, for: .highlighted)
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(self.fanTokenLogo))
            if let merchant = DataManager.shared.getMerchantInfo() {
                self.yellLabel.text = merchant.fantokenName ?? ""
            }
            self.balanceLabel.text = String(self.fanTokenBalance).formatPrice()
        }
        if let info = DataManager.shared.getReceiverInfo() {
            if CommonManager.checkLanguageJP {
                self.headerView.collapse(fullText: info.name ?? "")
            } else {
            self.headerView.setTitle(title: "\(StringConstants.s05TitleTransferTo.localized)\(info.name ?? "")")
            }
        }
        self.balanceView.isHidden = false
        self.swapTokenView.isHidden = true
        self.secondButton.setTitle(StringConstants.s05BtnTransfer.localized, for: .normal)
        self.secondButton.setTitle(StringConstants.s05BtnTransfer.localized, for: .highlighted)
    }
    
    private func setupTopUp() {
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            self.iconStableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            self.iconStableTokenImage1.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            self.yellLabel.text = stableToken.name
        }
        self.secondButton.setTitle(StringConstants.s04TopUp.localized, for: .normal)
        self.secondButton.setTitle(StringConstants.s04TopUp.localized, for: .highlighted)
        self.headerView.setTitle(title: StringConstants.s04TitleHeader.localized)
        self.firstButton.isHidden = true
        self.secondButton.isHidden = false
        self.balanceView.isHidden = true
        self.swapTokenView.isHidden = false
        self.viewModel.getStableTokenCustomer()
    }
    
    func pushToNormalPayDetailVC() {
        guard let amountInt = self.amountTextField.text?.formatPriceToInt() else { return }
        if amountInt >  self.payBalance {
            errorLabel.isHidden = false
            errorLabel.text = StringConstants.pleaseTopup.localized
            self.secondButton.isUserInteractionEnabled = false
            self.secondButton.backgroundColor = .colorE5E5E5
            self.secondButton.setTitleColor(.colorBlack111111, for: .normal)
            self.secondButton.setTitleColor(.colorBlack111111, for: .highlighted)
        } else {
            let vc = TransactionConfirmViewController(transactionType: .pay)
            switch self.payType {
            case .payPremoney:
                vc.amount = amountInt
                vc.payType = .payPremoney
            case .payWithoutCoupon:
                vc.amount = amountInt
                vc.payType = .payWithoutCoupon
            default:
                break
            }
            self.push(viewController: vc)
        }
    }
    
    func pushToExchangeDetail() {
        guard let amount = self.amountTextField.text?.formatPriceToInt() else {
            return
        }
        self.exchangeAmount = amount
        if amount > self.payBalance {
            self.errorLabel.isHidden = false
            self.errorLabel.text = StringConstants.pleaseTopup.localized
        } else {
            let confirmVC = TransactionConfirmViewController(transactionType: .exchange)
            confirmVC.fanTokenLogo = self.urlImageLogoFantoken
            confirmVC.amountExchange = self.exchangeAmount
            confirmVC.imageSTExchange = self.imageSTExchange
            confirmVC.balanceUserExchange = self.payBalance
            confirmVC.partnerId = self.partnerId
            push(viewController: confirmVC)
        }
    }
}

// MARK: - Actions
extension InputAmountTransactionViewController {
    
    @IBAction func downButtonAction(_ sender: CustomButton) {
        let amount = self.amountTextField.text?.formatPriceToInt() ?? 0
        switch self.transactionType {
        case .topUp:
            self.viewModel.topupCard(amount: amount)
        case .transfer:
            self.transferAction(amount: amount)
        case .pay:
            self.pushToNormalPayDetailVC()
        case .exchange:
            self.pushToExchangeDetail()
        default:
            break
        }
    }
    
    @IBAction func topUpAction(_ sender: UIButton) {
        switch self.transferType {
        case .transferStableToken:
            let topupViewController = TopupViewController()
            self.push(viewController: topupViewController)
        case .transferFantoken:
            guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
                return
            }
            let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
            inputAmountVC.partnerId = partnerInfo.id
            inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo ?? ""
            self.push(viewController: inputAmountVC)
        }
    }
    
    @IBAction func amountSelected(_ sender: UIButton) {
        let amount = sender.titleLabel?.text ?? ""
        if amount.count <= 15 {
            self.amountTextField.text = sender.titleLabel?.text ?? ""
        }
        self.secondButton.enable()
//        for (index, item) in self.amountButtonGroup.enumerated() {
//            let shouldSelected = amountTextField.text?.formatPrice() == self.outputAmounts[index].formatPrice()
//            item.backgroundColor = shouldSelected ? self.themeInfo.selectedColor : .white
//            item.setTitleColor(shouldSelected ? .colorBlack111111 : .colorB8B8B8, for: .normal)
//            item.layer.borderColor = shouldSelected ? self.themeInfo.secondaryColor.cgColor : UIColor.colorE5E5E5.cgColor
//            item.titleLabel?.font = shouldSelected ? .font(with: .bold700, size: 14) : .font(with: .medium500, size: 14)
//        }
    }
    
    private func transferAction(amount: Int) {
        switch self.transferType {
        case .transferStableToken:
            if amount <= self.viewModel.stableTokenCusomerInfo?.balance ?? 0 {
                let transactionConfirmViewController = TransactionConfirmViewController(transactionType: .transfer)
                transactionConfirmViewController.amount = amount
                transactionConfirmViewController.transferType = .transferStableToken
                self.push(viewController: transactionConfirmViewController)
            } else {
                errorLabel.isHidden = false
                errorLabel.text = StringConstants.pleaseTopup.localized
                self.secondButton.disable()
            }
        case .transferFantoken:
            if amount <= self.fanTokenBalance {
                let transactionConfirmViewController = TransactionConfirmViewController(transactionType: .transfer)
                transactionConfirmViewController.amount = amount
                transactionConfirmViewController.fanTokenLogo = self.fanTokenLogo
                transactionConfirmViewController.fanTokenType = self.fanTokenTicker
                transactionConfirmViewController.transferType = .transferFantoken
                self.push(viewController: transactionConfirmViewController)
            } else {
                errorLabel.isHidden = false
                errorLabel.text = StringConstants.s05LbPleaseExchange.localized
                self.secondButton.disable()
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension InputAmountTransactionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        self.exchangeEqualAmoutLabel.text = textFieldText.formatPrice()
        switch self.transactionType {
        case .topUp:
            return count <= 6
        case .pay, .exchange, .transfer:
            return count <= 15
        default:
            return count <= 12
        }
    }
}

// MARK: - InformGCMConfirm
extension InputAmountTransactionViewController: InformGCMConfirm {
    
    func confirmGuideline() {
        let viewController = GMOScreenViewController()
        viewController.externalLink = self.externalLink
        viewController.amount = self.amountTextField.text ?? "0"
        self.push(viewController: viewController)
    }
    
}

extension InputAmountTransactionViewController {
    
    func mapReccommnedAmount(amounts: [String]) {
        if amounts.count == 4 {
            for (index, item) in amounts.enumerated() {
                self.amountButtonGroup[index].setTitle(item.formatPrice(), for: .normal)
                self.amountButtonGroup[index].setTitle(item.formatPrice(), for: .highlighted)
            }
        }
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.topupButtonBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height + 14 : 50
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}

// MARK: - Handle UITextFieldDidChanged
extension InputAmountTransactionViewController {
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let amount = text.formatPriceToInt()
        self.errorLabel.isHidden = true
        self.errorLabel1.isHidden = true
        self.exceededView.isHidden = true
        textField.text = text.formatPrice()
        self.exchangeEqualAmoutLabel.text = text.formatPrice()
        if amount == 0 {
            self.exchangeStableTokenView.isHidden = true
            self.swapTokenView.isHidden = true
            self.outputAmounts = ["1000", "2000", "5000", "10000"]
        } else {
            switch self.transactionType {
            case .topUp:
                self.swapTokenView.isHidden = false
            case .exchange:
                self.exchangeStableTokenView.isHidden = false
            default:
                self.swapTokenView.isHidden = true
            }
            self.outputAmounts = self.viewModel.recommendAmount(amount: amount, transactionType: self.transactionType)
        }
        self.mapReccommnedAmount(amounts: self.outputAmounts)
        self.amountLabel.text = "= " + String(amount).formatPrice() + " ¥"
        
        text.formatPriceToInt() != 0 ? self.secondButton.enable() : self.secondButton.disable()
        //        for (index, item) in self.amountButtonGroup.enumerated() {
        //            let shouldSelected = text.formatPrice() == self.outputAmounts[index].formatPrice()
        //            item.backgroundColor = shouldSelected ? self.themeInfo.selectedColor : .white
        //            item.setTitleColor(shouldSelected ? .colorBlack111111 : .colorB8B8B8, for: .normal)
        //            item.layer.borderColor = shouldSelected ? self.themeInfo.secondaryColor.cgColor : UIColor.colorE5E5E5.cgColor
        //            item.titleLabel?.font = shouldSelected ? .font(with: .bold700, size: 14) : .font(with: .medium500, size: 14)
        //        }
    }
}
