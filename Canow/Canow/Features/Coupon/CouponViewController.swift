//
//  CouponViewController.swift
//  Canow
//
//  Created by hieplh2 on 30/12/2021.
//

import UIKit

enum CouponViewType {
    case use, redeem, redEnvelope, airdrop
}

class CouponViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s14TitleCouponDetail.localized)
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
    @IBOutlet private weak var banlanceStackView: UIStackView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var balanceImageView: UIImageView! {
        didSet {
            self.balanceImageView.image = {
                if let background = self.themeInfo.bgPattern7 {
                    return background
                } else {
                    return self.type == .use ? UIImage(named: "bg_balance") : UIImage(named: "bg_balance_remittance")
                }
            }()
        }
    }
    @IBOutlet weak var balanceTokenLogoImageView: UIImageView! {
        didSet {
            self.balanceTokenLogoImageView.rounded()
        }
    }
    @IBOutlet private weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.textColor = self.themeInfo.textColor
        }
    }
    @IBOutlet private weak var itemView: ItemView! {
        didSet {
            self.itemView.dropShadow()
            self.itemView.isHidden = self.type == .redeem
        }
    }
    @IBOutlet private weak var itemNameView: UIView!
    @IBOutlet private weak var itemRedeemView: ItemRedeemView! {
        didSet {
            self.itemRedeemView.dropShadow()
            self.itemRedeemView.isHidden = self.type != .redeem
        }
    }
    @IBOutlet private weak var priceLabel: UILabel! {
        didSet {
            self.priceLabel.text = {
                switch self.type {
                case .use, .redEnvelope, .airdrop:
                    return StringConstants.s15AmounttoPay.localized
                case .redeem:
                    return StringConstants.s14PriceOfCoupon.localized
                }
            }()
        }
    }
    
    @IBOutlet private weak var priceRedeemTextLabel: UILabel! {
        didSet {
            self.priceRedeemTextLabel.text = StringConstants.s15AmounttoPay.localized
        }
    }
    @IBOutlet private weak var descriptionTextLabel: UILabel! {
        didSet {
            self.descriptionTextLabel.text = StringConstants.s14Description.localized
        }
    }
    @IBOutlet private weak var itemNameLabel: UILabel! {
        didSet {
            self.itemNameLabel.text = StringConstants.s14Item.localized
        }
    }
    @IBOutlet private weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.text = StringConstants.s06Merchant.localized
        }
    }
    @IBOutlet private weak var couponInfoLabel: UILabel! {
        didSet {
            self.couponInfoLabel.text = StringConstants.s14CouponInfor.localized
        }
    }
    @IBOutlet private weak var priceImageView: UIImageView! {
        didSet {
            self.priceImageView.layer.cornerRadius = self.priceImageView.bounds.height/2
        }
    }
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var amountToPayView: UIView! {
        didSet {
            self.amountToPayView.isHidden = {
                switch self.type {
                case .use, .redEnvelope, .airdrop:
                    return true
                case .redeem:
                    return false
                }
            }()
        }
    }
    @IBOutlet private weak var balanceTextLabel: UILabel! {
        didSet {
            self.balanceTextLabel.text = StringConstants.s14Balance.localized
            self.balanceTextLabel.textColor = self.themeInfo.textColor.withAlphaComponent(0.5)
            self.balanceTextLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var merchantLabel: UILabel!
    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var priceRedeemImageView: UIImageView! {
        didSet {
            self.priceRedeemImageView.rounded()
        }
    }
    @IBOutlet private weak var priceRedeemLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var bottomButton: CustomButton! {
        didSet {
            self.bottomButton.setupUI()
        }
    }
    @IBOutlet private weak var upButton: UIButton! {
        didSet {
            self.upButton.isHidden = true
            self.upButton.setTitle(StringConstants.s15RemoveCoupon.localized, for: .normal)
            self.upButton.setTitle(StringConstants.s15RemoveCoupon.localized, for: .highlighted)
            self.upButton.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet weak var balanceView: UIView!
    
    // MARK: - Properties
    private var type: CouponViewType
    private var eCouponId: String
    private var viewModel = CouponViewModel()
    private var balance: Int = 0
    private var fantokenTicker: String
    private var merchantId: Int = 0
    private var bottomButtonTitle: String = "" {
        didSet {
            self.bottomButton.setTitle(bottomButtonTitle, for: .normal)
            self.bottomButton.setTitle(bottomButtonTitle, for: .highlighted)
        }
    }
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    private var teamId: Int = 0
    
    // MARK: - Constructors
    init(type: CouponViewType,
         eCouponId: String,
         fantokenTicker: String = "") {
        self.type = type
        self.eCouponId = eCouponId
        self.fantokenTicker = fantokenTicker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch self.type {
        case .redeem:
            self.bottomButton.setupUI()
        case .use, .redEnvelope, .airdrop:
            bottomButtonTitle = StringConstants.s06UseCoupon.localized
            switch self.viewModel.couponDetail?.couponType {
            case .coupon:
                bottomButtonTitle = StringConstants.s06UseCoupon.localized
            case .course, .redEnvelopeCoupon, .airdropCoupon:
                self.setupUseCoupon()
            default:
                break
            }
            self.setupExpiryDate()
        }
    }
    
    override func bindViewAndViewModel() {
        self.getCouponDetailSuccess()
        // self.redeemSuccess()
        self.redeemFailure()
        self.fetchDataFailure()
        self.getStableTokenCustomerSuccess()
        self.validateSuccess()
        self.removeCouponSuccess()
        self.getTeamInfo()
    }
    
}

// MARK: - Methods
extension CouponViewController {
    
    private func setupUI() {
        self.banlanceStackView.isHidden = KeychainManager.apiIdToken() == nil
        self.viewModel.getCouponDetail(eCouponId: self.eCouponId)
        switch self.type {
        case .use, .redEnvelope, .airdrop:
            self.viewModel.getStableTokenCustomer()
            if let stableToken = DataManager.shared.getStableTokenCustomer() {
                self.balanceTokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                self.priceImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            }
        case .redeem:
            self.upButton.isHidden = true
            self.amountToPayView.isHidden = false
            self.bottomButton.setTitle(StringConstants.s04BtnRedeem.localized, for: .normal)
            self.bottomButton.setTitle(StringConstants.s04BtnRedeem.localized, for: .highlighted)
            self.viewModel.getCustomerBalance(tokenType: self.fantokenTicker)
            if self.viewModel.couponDetail?.couponStatus == "Pending" {
                self.bottomButton.isEnabled = false
                self.bottomButton.setTitleColor(.colorE5E5E5, for: .normal)
                self.bottomButton.setTitleColor(.colorE5E5E5, for: .highlighted)
            }
            if KeychainManager.apiIdToken() == nil {
                if let stableToken = DataManager.shared.getStableTokenDefault() {
                    self.priceRedeemImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                }
            } else {
                if let stableToken = DataManager.shared.getStableTokenCustomer() {
                    self.priceRedeemImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                }
                
            }
        }
    }
    
    private func setupUseCoupon() {
        let date = Date().localDate()
        if let usableDate = self.viewModel.couponDetail?.usableFrom?.toDate(dateFormat: DateFormat.DATE_CURRENT) {
            self.itemNameView.isHidden = self.viewModel.couponDetail?.couponType == .course
            if usableDate > date {
                bottomButtonTitle = StringConstants.s15BtnUsableFrom.localized + usableDate.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
                self.bottomButton.isUserInteractionEnabled = false
                self.bottomButton.backgroundColor = .colorE5E5E5
                self.bottomButton.setTitleColor(.color646464, for: .normal)
                self.bottomButton.setTitleColor(.color646464, for: .highlighted)
                self.hideBalanceView()
            } else {
                if let expiredDate = self.viewModel.couponDetail?.expiredDate.toDate(dateFormat: DateFormat.DATE_CURRENT) {
                    if date >= usableDate && date <= expiredDate {
                        bottomButtonTitle = StringConstants.s06UseCoupon.localized
                        self.bottomButton.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    
    private func setupExpiryDate() {
        if let expiryDate = self.viewModel.couponDetail?.expiredDate.toDate(dateFormat: DateFormat.DATE_CURRENT) {
            self.upButton.isHidden = expiryDate > Date().localDate()
            if expiryDate < Date().localDate() {
                bottomButtonTitle = StringConstants.s06UseCoupon.localized
                self.bottomButton.isUserInteractionEnabled = false
                self.bottomButton.backgroundColor = .colorE5E5E5
                self.bottomButton.setTitleColor(.colorBlack111111, for: .normal)
                self.bottomButton.setTitleColor(.color646464, for: .highlighted)
                self.hideBalanceView()
            }
        }
    }
    
    private func getCouponDetailSuccess() {
        self.viewModel.getCouponDetailSuccess = {
            CommonManager.hideLoading()
            self.topImageView.kf.setImage(with: CommonManager.getImageURL(self.viewModel.couponDetail?.merchantLogo))
            switch self.type {
            case .use, .redEnvelope, .airdrop:
                self.setupDataUseCoupon()
            case .redeem:
                self.setupDataRedeemCoupon()
            }
            self.merchantLabel.text = self.viewModel.couponDetail?.merchantName
            self.itemLabel.text = self.viewModel.couponDetail?.itemName
            self.descriptionLabel.text = self.viewModel.couponDetail?.description.htmlToString
        }
    }
    
    private func getStableTokenCustomerSuccess() {
        self.viewModel.getStableMobileInfSuccess = {
            if let stableToken = self.viewModel.stableToken {
                self.balanceTokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                self.priceImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                self.priceRedeemImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                
            }
        }
        switch self.type {
        case .use, .redEnvelope, .airdrop:
            self.viewModel.fetchStableTokenSuccess = { stableTokenCustomerInfo in
                self.balanceLabel.text = "\(stableTokenCustomerInfo.balance ?? 0)".formatPrice()
                self.balance = stableTokenCustomerInfo.balance ?? 0
            }
        case .redeem:
            self.viewModel.fetchFantokenBalanceInfo = {
                self.balanceTokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(self.viewModel.fantokenInfo?.fanTokenLogo))
                self.priceImageView.kf.setImage(with: CommonManager.getImageURL(self.viewModel.fantokenInfo?.fanTokenLogo))
                let fanTokenBalance = self.viewModel.fantokenInfo?.fanTokenBalance ?? 0
                self.balance = fanTokenBalance
                self.balanceLabel.text = "\(self.balance)".formatPrice()
            }
        }
        
    }
    
    private func validateSuccess() {
        self.viewModel.validateSuccess = { transactionId in
            CommonManager.hideLoading()
            switch self.type {
            case .use:
                let transactionConfirmViewController = TransactionConfirmViewController(transactionType: .useCoupon)
                transactionConfirmViewController.amount = self.viewModel.couponDetail?.payPrice ?? 0
                transactionConfirmViewController.eCouponId = self.eCouponId
                transactionConfirmViewController.merchantId = self.merchantId
                transactionConfirmViewController.transactionId = transactionId
                transactionConfirmViewController.couponDetail = self.viewModel.couponDetail
                self.push(viewController: transactionConfirmViewController)
            case .redeem:
                let transactionConfirmViewController = TransactionConfirmViewController(transactionType: .redeemCoupon)
                transactionConfirmViewController.amount = self.viewModel.couponDetail?.price ?? 0
                transactionConfirmViewController.eCouponId = self.eCouponId
                transactionConfirmViewController.transactionId = transactionId
                transactionConfirmViewController.couponDetail = self.viewModel.couponDetail
                transactionConfirmViewController.fanTokenLogo = self.viewModel.fantokenInfo?.fanTokenLogo ?? ""
                self.push(viewController: transactionConfirmViewController)
            case .redEnvelope:
                let transactionConfirmViewController = TransactionConfirmViewController(transactionType: .useCouponRedEnvelopeEvent)
                transactionConfirmViewController.amount = self.viewModel.couponDetail?.payPrice ?? 0
                transactionConfirmViewController.eCouponId = self.eCouponId
                transactionConfirmViewController.merchantId = self.merchantId
                transactionConfirmViewController.transactionId = transactionId
                transactionConfirmViewController.couponDetail = self.viewModel.couponDetail
                self.push(viewController: transactionConfirmViewController)
            case .airdrop:
                let transactionConfirmViewController = TransactionConfirmViewController(transactionType: .useCouponAirdropEvent)
                transactionConfirmViewController.amount = self.viewModel.couponDetail?.payPrice ?? 0
                transactionConfirmViewController.eCouponId = self.eCouponId
                transactionConfirmViewController.merchantId = self.merchantId
                transactionConfirmViewController.transactionId = transactionId
                transactionConfirmViewController.couponDetail = self.viewModel.couponDetail
                self.push(viewController: transactionConfirmViewController)
            }
            
        }
    }
    
    private func removeCouponSuccess() {
        self.viewModel.removeCouponSuccess = {
            CommonManager.hideLoading()
            self.pop()
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataRedeemFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            self.showPopup(title: error,
                           message: StringConstants.s14RedeemOtherCoupons.localized,
                           popupBg: UIImage(named: "bg_failed_tiny"),
                           titleFont: .font(with: .bold700, size: 16),
                           messageFont: .font(with: .regular400, size: 14),
                           rightButton: ("OK", {
                self.dismiss(animated: true)
                self.pop()
            }))
        }
        
        self.viewModel.fetchFantokenBalanceInfoFailure = { _ in
            CommonManager.hideLoading()
            if let merchant = DataManager.shared.getMerchantInfo() {
                self.balanceTokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(merchant.fantokenLogo))
                self.priceImageView.kf.setImage(with: CommonManager.getImageURL(merchant.fantokenLogo))
            }
            self.balance = 0
            self.balanceLabel.text = "0"
        }
        
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            switch error {
            case MessageCode.E017.message:
                self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                               message: StringConstants.s15MessagePleaseTopup.localized,
                               popupBg: UIImage(named: "bg_yourBalance"),
                               titleFont: .font(with: .bold700, size: 16),
                               messageFont: .font(with: .regular400, size: 14),
                               leftButton: (StringConstants.s01BtnCancel.localized, {}),
                               rightButton: (StringConstants.s04BtnTopupPopup.localized, {
                    self.dismiss(animated: true)
                    let viewController = TopupViewController()
                    self.push(viewController: viewController)
                }))
            default:
                break
            }
        }
        
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func setupDataUseCoupon() {
        self.itemView.itemUrl = self.viewModel.couponDetail?.image
        self.itemView.merchantName = self.viewModel.couponDetail?.merchantName
        self.itemView.couponName = self.viewModel.couponDetail?.couponName
        self.itemView.expireDate = self.viewModel.couponDetail?.expiredDate.formatDateString()
        self.priceValueLabel.text = String(self.viewModel.couponDetail?.payPrice ?? 0).formatPrice()
        self.teamId = self.viewModel.couponDetail?.teamId ?? 0
        self.headerView.onBack = {
            switch self.type {
            case .use, .redeem, .airdrop:
                self.pop()
            case .redEnvelope:
                if self.teamId == DataManager.shared.getCustomerInfo()?.teamId {
                    self.popToRoot()
                    NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                } else {
                    self.viewModel.getTeamInfoSelected(partnerId: self.teamId)
                }
            }
        }
    }
    
    private func setupDataRedeemCoupon() {
        self.itemRedeemView.itemUrl = self.viewModel.couponDetail?.image
        self.itemRedeemView.merchantName = self.viewModel.couponDetail?.merchantName
        self.itemRedeemView.couponName = self.viewModel.couponDetail?.couponName
        self.itemRedeemView.usableDate = self.viewModel.couponDetail?.availableTo.formatDateString()
        self.itemRedeemView.expireDate = self.viewModel.couponDetail?.expiredDate.formatDateString()
        let quantity = self.viewModel.couponDetail?.quantity ?? 0
        let redeemedQuantity = Int(self.viewModel.couponDetail?.redeemedQuantity ?? "0") ?? 0
        let remaining = Int(self.viewModel.couponDetail?.remainingQuantity ?? "0") ?? 0
        self.itemRedeemView.progressCurrent = redeemedQuantity
        self.itemRedeemView.progressTotal = quantity
        self.itemRedeemView.progressRemaining = remaining
        self.priceValueLabel.text = String(self.viewModel.couponDetail?.price ?? 0).formatPrice()
        self.priceRedeemLabel.text = String(self.viewModel.couponDetail?.payPrice ?? 0).formatPrice()
    }
    private func redeemFailure() {
        self.viewModel.redeemFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            switch error {
            case MessageCode.E034.message:
                self.showPopup(title: StringConstants.s14TitleCouponInactiveNormalRedeem.localized,
                               message: StringConstants.s14RedeemOtherCoupons.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true)
                    self.pop() }))
            case MessageCode.E033.message:
                self.showPopup(title: StringConstants.s14TitleSoldOutNormalCoupon.localized,
                               message: StringConstants.s14MessageSoldOutNormalCoupon.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true)
                    self.pop() }))
            case MessageCode.E017.message:
                self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                               message: StringConstants.s14Message_ExchangeMore.localized,
                               popupBg: UIImage(named: "bg_yourBalance"),
                               titleFont: .font(with: .bold700, size: 16),
                               messageFont: .font(with: .regular400, size: 14),
                               leftButton: (StringConstants.s01BtnCancel.localized, {
                    self.setupUI()
                }),
                               rightButton: (StringConstants.s05BtnExchange.localized, {self.showAlert()}))
            default:
                self.showAlert(title: "Error", message: error)
            }
        }
    }
    
    private func getTeamInfo() {
        self.viewModel.fetchTeamSelected = {
            CommonManager.hideLoading()
            let homePageVC = HomePageViewController()
            DataManager.shared.saveCheck(check: .redEnvelope)
            homePageVC.checkFantokenPush = .redEnvelope
            self.navigationController?.viewControllers.insert(homePageVC, at: 1)
            self.popTo(viewController: homePageVC)
        }
    }
    
    private func hideBalanceView() {
        //        self.couponViewTopConstraint.constant = -16
        self.balanceView.isHidden = true
    }
    
}

// MARK: - Actions
extension CouponViewController {
    
    @IBAction func actionBottomButton(_ sender: CustomButton) {
        if !CommonManager.checkLandingPage() {
            return
        }
        switch self.type {
        case .use, .redEnvelope, .airdrop:
            self.useCouponAction()
        case .redeem:
            self.redeemAction()
        }
    }
    
    @IBAction func actionUpButton(_ sender: UIButton) {
        switch self.type {
        case .use, .redEnvelope, .airdrop:
            self.showPopup(title: StringConstants.s15TitleRemoveCoupon.localized,
                           message: "",
                           popupBg: UIImage(named: "bg_error_coupon"),
                           titleFont: .font(with: .bold700, size: 16),
                           messageFont: .font(with: .regular400, size: 14),
                           leftButton: (StringConstants.s01BtnCancel.localized, {}),
                           rightButton: (StringConstants.s04BtnConfirmPopup.localized, {
                self.viewModel.removeCoupon(eCouponId: self.eCouponId)
            }))
        case .redeem:
            break
        }
    }
    
    private func redeemAction() {
        let amountToPay = self.priceValueLabel.text?.formatPriceToInt() ?? 0
        if self.balance < amountToPay {
            self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                           message: StringConstants.s14Message_ExchangeMore.localized,
                           popupBg: UIImage(named: "bg_yourBalance"),
                           titleFont: .font(with: .bold700, size: 16),
                           messageFont: .font(with: .regular400, size: 14),
                           leftButton: (StringConstants.s01BtnCancel.localized, {}),
                           rightButton: (StringConstants.s05BtnExchange.localized, {self.showAlert()}))
        } else {
            self.viewModel.checkRedeemCoupon(eCouponId: self.viewModel.couponDetail?.couponId ?? "")
        }
    }
    
    private func showAlert() {
        self.dismiss(animated: true, completion: nil)
        guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
            return
        }
        let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
        inputAmountVC.partnerId = partnerInfo.id
        inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo!
        self.push(viewController: inputAmountVC)
    }
    
    private func useCouponAction() {
        if self.balance < self.viewModel.couponDetail?.payPrice ?? 0 {
            self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                           message: StringConstants.s15MessagePleaseTopup.localized,
                           popupBg: UIImage(named: "bg_yourBalance"),
                           titleFont: .font(with: .bold700, size: 16),
                           messageFont: .font(with: .regular400, size: 14),
                           leftButton: (StringConstants.s01BtnCancel.localized, {}),
                           rightButton: (StringConstants.s06ExchangeTopUp.localized, {
                self.dismiss(animated: true)
                let viewController = TopupViewController()
                self.push(viewController: viewController)
            }))
        } else {
            self.openCamera(checkPermissionOnly: true) { _ in
                let scanQRVC = ScanQRViewController()
                switch self.type {
                case .use:
                    scanQRVC.transactionType = .useCoupon
                case.redEnvelope:
                    scanQRVC.transactionType = .useCouponRedEnvelopeEvent
                case.airdrop:
                    scanQRVC.transactionType = .useCouponAirdropEvent
                case .redeem:
                    break
                }
                scanQRVC.couponDetailInfo = self.viewModel.couponDetail
                scanQRVC.delegate = self
                scanQRVC.modalPresentationStyle = .overFullScreen
                self.present(viewController: scanQRVC)
            }
        }
    }
    
}

// MARK: - ScanQRResultDelegate
extension CouponViewController: ScanQRDelegate {
    
    func scanResult<T>(model: T) {
        guard let qrCouponUse = model as? QRCouponUse else {
            return
        }
        self.merchantId = qrCouponUse.partnerId
        self.viewModel.checkUseCoupon(partnerId: qrCouponUse.partnerId, eCouponId: self.viewModel.couponDetail?.eCouponId ?? "")
    }
    
}

// MARK: - Calculate days
extension CouponViewController {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let numberOfDays = Calendar.current.dateComponents([.day], from: from, to: to)
        return numberOfDays.day!
    }
    
}
