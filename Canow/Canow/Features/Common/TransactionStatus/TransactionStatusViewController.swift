//
//  TransactionStatusViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//

import UIKit
import Kingfisher
import AVFoundation

enum TopupType: CaseIterable {
    case creditCard, giftCard
}

class TransactionStatusViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s04TitleTransactionDetail.localized)
            self.headerView.backButtonHidden = true
        }
    }
    @IBOutlet private weak var transactionProcessingLabel: UILabel! {
        didSet {
            self.transactionProcessingLabel.font = .font(with: .bold700, size: 16)
            self.transactionProcessingLabel.textColor = .colorBlack111111
            self.transactionProcessingLabel.text = StringConstants.s04TransactionProcessing.localized
        }
    }
    @IBOutlet private weak var transactionScrollView: UIScrollView! {
        didSet {
            self.transactionScrollView.isDirectionalLockEnabled = true
            self.transactionScrollView.dropShadow()
        }
    }
    @IBOutlet weak var bgImageView: UIImageView! {
        didSet {
            self.bgImageView.image = self.themeInfo.bgPattern2
        }
    }
    @IBOutlet weak var cardBackgroundView: CardBackgroundView!
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var ticketView: UIView! {
        didSet {
            self.ticketView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var backHomeButton: CustomButton! {
        didSet {
            self.backHomeButton.layer.cornerRadius = 6
            self.backHomeButton.setupUI()
            switch self.transactionType {
            case .remittance:
                self.backHomeButton.setTitle(StringConstants.s17BtnTeamPage.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s17BtnTeamPage.localized, for: .highlighted)
            default:
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
            }
        }
    }
    @IBOutlet private weak var tryAgainButton: CustomButton! {
        didSet {
            self.tryAgainButton.layer.cornerRadius = 6
            self.tryAgainButton.setupUI()
            self.tryAgainButton.setTitle(StringConstants.s04BtnTryAgain.localized, for: .normal)
            self.tryAgainButton.setTitle(StringConstants.s04BtnTryAgain.localized, for: .highlighted)
        }
    }
    @IBOutlet private weak var transactionPendingStackView: UIStackView!
    @IBOutlet private weak var transactionPendingLabel: UILabel! {
        didSet {
            self.transactionPendingLabel.textColor = .color646464
            self.transactionPendingLabel.font = .font(with: .medium500, size: 12)
            self.transactionPendingLabel.text = StringConstants.s04MessageProcesssing.localized
        }
    }
    @IBOutlet private weak var transactionStatusView: TransactionStatusView!
    
    // MARK: - Properties
    var fanTokenLogo: String = ""
    var teamFantokenTickerRedeem: String = ""
    var teamFantokenTickerExchange: String = ""
    var transactionId: String = ""
    var tokenType: String = ""
    var couponDetail: CouponDetailInfo?
    var courseDetail: CourseDetailInfo?
    var receiverCustomer: StableTokenCustomerInfo?
    var teamSelected : TeamSelectedInfo?
    var transactionType: TransactionType = .transfer
    var payType: PayType = .payPremoney
    var topUpType: TopupType = .creditCard
    var transferType: TransferType = .transferStableToken
    var couponInfo: CouponMerchantInfo?
    var eCouponInfo: EcouponInfo?
    var amount: Int = 0
    private var timeRemaining: Int = 7
    private var timer: Timer!
    private let viewModel = TransactionStatusViewModel()
    var merchantName: String = ""
    var merchantImageProperties: String = ""
    var merchantId: Int = 0
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    private var audioPlayer : AVAudioPlayer!
    
    var remittanceToAvatar: String = ""
    var remittanceItemAmount: Int = 0
    var remittanceItemName: String = ""
    var remittanceNameLabel: String = ""
    
    // Exchange
    var amountExchange: Int = 0
    var imageFT: String = ""
    var imageST: String = ""
    var surplusBalance: Int = 0
    var transactionStatusDesc = ""
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.fetchDataSuccess()
        self.fetchDataFailure()
        self.getInfoTeamSelected()
        self.getInfoTeamSelectedFailure()
    }
    
}

// MARK: - Methods
extension TransactionStatusViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        switch self.transactionType {
        case .topUp:
            self.setupTopup()
        case .transfer:
            self.setupTransfer()
        case .pay:
            self.setupPay()
        case .redeemCoupon:
            self.setupRedeemCoupon()
        case .redeemCourse:
            self.setupRedeemCourse()
        case .useCoupon, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
            self.setupUseCoupon()
        case .remittance:
            self.setupRemittanceCampaignView()
        case .exchange:
            self.setupExchangeView()
        default:
            break
        }
        if self.transactionId == "" {
            self.transactionPendingStackView.isHidden = true
            self.transactionScrollView.isHidden = false
            self.transactionStatusView.amount = self.amountExchange
            self.transactionStatusView.fanTokenLogo = self.fanTokenLogo
            self.transactionStatusView.priceValue = "\(self.amountExchange)".formatPrice()
            self.transactionStatusView.date = Date().toStringProfile(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
            self.transactionStatusView.status = MessageCode.E028.message
            self.backHomeButton.isHidden = false
            self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .highlighted)
            return
        }
        self.viewModel.getTransactionStatus(transactionId: self.transactionId)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        ConnectionManager.shared.connectInternet = {
            self.viewModel.getTransactionStatus(transactionId: self.transactionId)
        }
    }
    
    private func setupExchangeView() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .exchange)
        CommonManager.hideLoading()
        
        guard let sender = DataManager.shared.getCustomerInfo() else { return }
        self.transactionStatusView.detailImageUrl = sender.avatar ?? ""
        self.transactionStatusView.maintDetal = sender.fullname
        self.transactionStatusView.subDetail = sender.userName
        self.transactionStatusView.fanTokenLogo = self.imageFT
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.transactionStatusView.stableTokenLogo = stableToken.logo
        }
    }
    
    private func setupRemittanceCampaignView() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .remittance)
        self.transactionStatusView.fanTokenLogo = self.fanTokenLogo
        self.transactionStatusView.detailImageUrl = self.remittanceToAvatar
        self.transactionStatusView.maintDetal = self.remittanceItemName
        self.transactionStatusView.subDetail = self.remittanceNameLabel
    }
    
    private func setupTopup() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .topUp)
        let customer = DataManager.shared.getCustomerInfo()
        self.transactionStatusView.detailImageUrl = customer?.avatar ?? ""
        self.transactionStatusView.maintDetal = customer?.fullname ?? ""
        self.transactionStatusView.subDetail = customer?.userName ?? ""
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.transactionStatusView.fanTokenLogo = stableToken.logo
        }
    }
    
    private func setupTransfer() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .transfer)
        
        switch self.transferType {
        case .transferStableToken:
            if let stableToken = DataManager.shared.getStableTokenCustomer() {
                self.transactionStatusView.fanTokenLogo = stableToken.logo
            }
        case .transferFantoken:
            self.transactionStatusView.fanTokenLogo = self.fanTokenLogo
        }
        if let receiver = DataManager.shared.getReceiverInfo() {
            self.transactionStatusView.detailImageUrl = receiver.avatar ?? ""
            self.transactionStatusView.maintDetal = receiver.name ?? ""
            self.transactionStatusView.subDetail = receiver.phone ?? ""
        }
    }
    
    private func setupPay() {
        self.transactionStatusView.isHidden = false
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.transactionStatusView.fanTokenLogo = stableToken.logo
        }
        switch self.payType {
        case .payDiscountCoupon:
            self.transactionStatusView.setup(transactionType: .pay, payType: .payDiscountCoupon)
            if let merchant = DataManager.shared.getMerchantInfo(), let eCouponInfo = self.eCouponInfo {
                self.transactionStatusView.merchantImageUrl = merchant.logo
                self.transactionStatusView.couponImageUrl = eCouponInfo.image
                self.transactionStatusView.merchantName = eCouponInfo.merchantName
                self.transactionStatusView.couponName = eCouponInfo.couponName
                self.transactionStatusView.itemName = eCouponInfo.itemName
                self.transactionStatusView.merchantName2 = merchant.name
            }
        case .payWithoutCoupon, .payPremoney:
            self.transactionStatusView.isHidden = false
            self.transactionStatusView.setup(transactionType: .pay, payType: .payWithoutCoupon)
            if let merchant = DataManager.shared.getMerchantInfo() {
                self.transactionStatusView.merchantImageUrl = merchant.logo
                self.transactionStatusView.merchantName2 = merchant.name
            }
        }
    }
    
    private func setupRedeemCoupon() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .redeemCoupon)
        self.transactionStatusView.fanTokenLogo = self.fanTokenLogo
        self.transactionStatusView.couponImageUrl = self.couponDetail?.image ?? ""
        self.transactionStatusView.merchantName = self.couponDetail?.merchantName ?? ""
        self.transactionStatusView.couponName = self.couponDetail?.couponName ?? ""
        self.transactionStatusView.itemName = self.couponDetail?.itemName ?? ""
        self.transactionStatusView.merchantName2 = self.couponDetail?.merchantName ?? ""
    }
    
    private func setupRedeemCourse() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .redeemCourse)
        self.transactionStatusView.amount = self.courseDetail?.price ?? 0
        self.transactionStatusView.fanTokenLogo = self.fanTokenLogo
        self.transactionStatusView.couponImageUrl = self.courseDetail?.image ?? ""
        self.transactionStatusView.merchantName = self.courseDetail?.merchantName ?? ""
        self.transactionStatusView.couponName = self.courseDetail?.couponName ?? ""
        self.transactionStatusView.merchantName2 = self.couponDetail?.merchantName ?? ""
        self.transactionStatusView.itemName = "\(StringConstants.s17LbExpiryDate.localized) \(self.courseDetail?.expiredDate.formatDateString() ?? "")"
        self.transactionStatusView.usableFrom = "\(StringConstants.s17LbUsableFrom.localized) \(self.courseDetail?.usableFrom.formatDateString() ?? "")"
    }
    
    private func setupUseCoupon() {
        self.transactionStatusView.isHidden = false
        self.transactionStatusView.setup(transactionType: .useCoupon)
        self.transactionStatusView.couponImageUrl = self.couponDetail?.image ?? ""
        self.transactionStatusView.merchantName = self.couponDetail?.merchantName ?? ""
        self.transactionStatusView.couponName = self.couponDetail?.couponName ?? ""
        self.transactionStatusView.itemName = self.couponDetail?.itemName ?? ""
        self.transactionStatusView.merchantName2 = self.couponDetail?.merchantName ?? ""
        self.transactionStatusView.merchantImageUrl = self.couponDetail?.merchantLogo ?? ""
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.transactionStatusView.fanTokenLogo = stableToken.logo
        }
    }
    
    private func fetchDataSuccess() {
        self.viewModel.fetchGiftCardSuccess = {
            self.viewModel.getTransactionStatus(transactionId: self.transactionId)
        }
        
        self.viewModel.fetchTransactionStatusSuccess = {
            CommonManager.hideLoading()
            guard let transaction = self.viewModel.transactionStatus else { return }
            
            self.transactionStatusView.amount = transaction.amount ?? 0
            self.transactionStatusView.priceValue = self.transactionType == .topUp ? String(transaction.amount ?? 0).formatPrice() + "¥" :
            String(transaction.amount ?? 0).formatPrice()
            self.transactionStatusView.date = transaction.createdAt?.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? ""
            
            switch transaction.status {
            case .completed:
                self.handleTransactionComplete()
            case .failed:
                self.handleTransactionFail()
            case .pending:
                self.viewModel.getTransactionStatus(transactionId: self.transactionId)
            default:
                break
            }
        }
        
        self.viewModel.transactionSuccess = { transactionResult in
            self.viewModel.getTransactionStatus(transactionId: transactionResult.data.stringValue)
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func handleTransactionComplete() {
        switch self.transactionType {
        case .pay, .useCoupon, .useCourse, .useCouponWithoutPayment, .useCouponAirdropEvent, .useCouponRedEnvelopeEvent:
            if self.viewIfLoaded?.window != nil {
                self.playAudioFromProject()
            }
        default:
            break
        }
        self.cardBackgroundView.isHidden = true
        self.bgImageView.isHidden = false
        self.contentView.backgroundColor = self.themeInfo.bgPattern1 != nil ? .clear : .white
        self.timer.invalidate()
        self.transactionScrollView.isHidden = false
        self.transactionPendingStackView.isHidden = true
        self.backHomeButton.isHidden = false
        self.transactionPendingLabel.isHidden = true
        self.transactionStatusView.handleTransactionStatus(status: .completed)
        switch self.transactionType {
        case .redeemCoupon, .useCoupon, .exchange, .redeemCourse, .remittance, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
            self.tryAgainButton.isHidden = true
            self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .highlighted)
        case .transfer:
            self.tryAgainButton.isHidden = true
            switch self.transferType {
            case .transferFantoken:
                self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .highlighted)
            case .transferStableToken:
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
            }
        case .topUp:
            self.tryAgainButton.isHidden = false
            self.tryAgainButton.backgroundColor = .colorE5E5E5
            self.tryAgainButton.setTitleColor(.colorBlack111111, for: .normal)
            self.tryAgainButton.setTitleColor(.colorBlack111111, for: .highlighted)
            self.tryAgainButton.setTitle(StringConstants.s04BtnNewTopup.localized, for: .normal)
            self.tryAgainButton.setTitle(StringConstants.s04BtnNewTopup.localized, for: .highlighted)
            self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
        default:
            self.tryAgainButton.isHidden = true
            self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
        }
    }
    
    private func handleTransactionFail() {
        self.cardBackgroundView.isHidden = true
        self.bgImageView.isHidden = false
        self.contentView.backgroundColor = self.themeInfo.bgPattern1 != nil ? .clear : .white
        self.timer.invalidate()
        self.transactionScrollView.isHidden = false
        self.transactionPendingStackView.isHidden = true
        self.tryAgainButton.isHidden = false
        self.transactionPendingLabel.isHidden = true
        self.transactionStatusView.handleTransactionStatus(status: .failed)
        
        self.tryAgainButton.setTitle(StringConstants.s04BtnTryAgain.localized, for: .normal)
        self.tryAgainButton.setTitle(StringConstants.s04BtnTryAgain.localized, for: .highlighted)
        self.backHomeButton.isHidden = false
        self.backHomeButton.backgroundColor = .colorE5E5E5
        self.backHomeButton.setTitleColor(.colorBlack111111, for: .normal)
        self.backHomeButton.setTitleColor(.colorBlack111111, for: .highlighted)
        switch self.transactionType {
        case .remittance, .redeemCourse, .redeemCoupon, .useCoupon, .useCouponRedEnvelopeEvent:
            self.backHomeButton.setTitle(StringConstants.s17BtnTeamPage.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.s17BtnTeamPage.localized, for: .highlighted)
        case .exchange:
            self.backHomeButton.setTitle(StringConstants.exchangeBackTeam.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.exchangeBackTeam.localized, for: .highlighted)
        case .transfer:
            switch self.transferType {
            case .transferFantoken:
                self.backHomeButton.setTitle(StringConstants.s17BtnTeamPage.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s17BtnTeamPage.localized, for: .highlighted)
            case .transferStableToken:
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
            }
        default:
            self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
            self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
        }
    }
    
    private func getInfoTeamSelected() {
        self.viewModel.getPartnerInfSuccess = {
            CommonManager.hideLoading()
            let homePageVC = HomePageViewController()
//            DataManager.shared.saveCheck(check: .redEnvelope)
            homePageVC.checkFantokenPush = .fanToken
            self.navigationController?.viewControllers.insert(homePageVC, at: 1)
            self.popTo(viewController: homePageVC)
        }
    }
    
    private func getInfoTeamSelectedFailure() {
        self.viewModel.getPartnerInfFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
}

// MARK: - Actions
extension TransactionStatusViewController {
    
    @IBAction func backToHome(_ sender: UIButton) {
        if transactionId == "" {
            self.backToTeamPage()
            return
        }
        if self.viewModel.transactionStatus?.status == .pending || self.viewModel.transactionStatus?.status == nil {
            var rightButton = (StringConstants.s04BtnOk.localized, {
                self.dismiss(animated: true, completion: nil)
                self.popToRoot() })
            switch self.transactionType {
            case .transfer:
                switch self.transferType {
                case .transferStableToken:
                    rightButton = (StringConstants.s04BtnOk.localized, { self.backToHomePage() })
                case .transferFantoken:
                    rightButton = (StringConstants.s04BtnOk.localized, { self.backToTeamPage() })
                }
            case .redeemCoupon, .useCoupon, .redeemCourse, .remittance, .exchange:
                rightButton = (StringConstants.s04BtnOk.localized, { self.backToTeamPage() })
            case .pay, .topUp:
                rightButton = (StringConstants.s04BtnOk.localized, { self.backToHomePage() })
            case .useCouponRedEnvelopeEvent:
                rightButton = (StringConstants.s04BtnOk.localized, { self.redEnvelopeBackToTeamPage() })
            default:
                rightButton = (StringConstants.s04BtnOk.localized, { self.popToRoot() })
            }
            self.showPopup(title: StringConstants.s04TitleGoback.localized,
                           message: StringConstants.s04MessageGoback.localized, popupBg: UIImage(named: "ic_back_alert"),
                           titleFont: .font(with: .bold700, size: 16),
                           messageFont: .font(with: .regular400, size: 14),
                           leftButton: (StringConstants.s01BtnCancel.localized, {}),
                           rightButton: rightButton)
        } else {
            switch self.transactionType {
            case .pay, .topUp:
                self.backToHomePage()
            case .transfer:
                switch self.transferType {
                case .transferStableToken:
                    self.backToHomePage()
                case .transferFantoken:
                    self.backToTeamPage()
                }
            case .redeemCoupon, .useCoupon, .exchange, .redeemCourse, .remittance, .useCouponAirdropEvent:
                self.backToTeamPage()
            case .useCouponRedEnvelopeEvent:
                self.redEnvelopeBackToTeamPage()
            default:
                self.popToRoot()
            }
        }
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        switch self.transactionType {
        case .topUp:
            switch self.topUpType {
            case .giftCard:
                self.navigationController?.viewControllers.forEach({ (vc) in
                    if let topupGiftCardViewController = vc as? TopupGiftCardViewController {
                        self.popTo(viewController: topupGiftCardViewController)
                    }
                })
            case .creditCard:
                self.navigationController?.viewControllers.forEach({ (vc) in
                    if let inputAmpountViewController = vc as? InputAmountTransactionViewController {
                        self.popTo(viewController: inputAmpountViewController)
                    }
                })
            }
        case .remittance:
            self.pop()
        case .redeemCoupon, .redeemCourse, .useCoupon, .exchange, .transfer, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
            self.navigationController?.viewControllers.forEach({ (vc) in
                if  let transactionConfirmViewController = vc as? TransactionConfirmViewController {
                    self.popTo(viewController: transactionConfirmViewController)
                }
            })
        case .pay:
            switch self.payType {
            case .payDiscountCoupon, .payWithoutCoupon:
                self.navigationController?.viewControllers.forEach({ (vc) in
                    if let payViewController = vc as? PayViewController {
                        self.popTo(viewController: payViewController)
                    }
                })
            case .payPremoney:
                self.navigationController?.viewControllers.forEach({ (vc) in
                    if  let inputAmountTransactionViewController = vc as? InputAmountTransactionViewController {
                        self.popTo(viewController: inputAmountTransactionViewController)
                    }
                })
            }
        default:
            self.popToRoot()
        }
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            self.transactionPendingLabel.isHidden = false
            self.backHomeButton.isHidden = false
            self.tryAgainButton.isHidden = true
            switch self.transactionType {
            case .redeemCoupon, .useCoupon, .exchange, .redeemCourse, .remittance, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
                self.tryAgainButton.isHidden = true
                self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .highlighted)
            case .transfer:
                self.tryAgainButton.isHidden = true
                switch self.transferType {
                case .transferFantoken:
                    self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .normal)
                    self.backHomeButton.setTitle(StringConstants.s17BtnBackToTeamPage.localized, for: .highlighted)
                case .transferStableToken:
                    self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
                    self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
                }
            default:
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .normal)
                self.backHomeButton.setTitle(StringConstants.s04BtnBackHome.localized, for: .highlighted)
            }
            
        }
    }
    
    private func backToTeamPage() {
        self.dismiss(animated: true, completion: nil)
        switch DataManager.shared.isFanToken() {
        case .home:
            self.popToRoot()
            NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
        case .fanToken:
            self.navigationController?.viewControllers.forEach({ (vc) in
                if  let homePageViewController = vc as? HomePageViewController {
                    self.popTo(viewController: homePageViewController)
                }
            })
        default:
            self.popToRoot()
            NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
        }
    }
    
    private func redEnvelopeBackToTeamPage() {
        self.viewModel.getTeamInfoSelected(partnerId: self.couponDetail?.teamId ?? 0)
    }
    
    private func backToHomePage() {
        self.dismiss(animated: true, completion: nil)
        self.popToRoot()
        NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
    }
    
    private func playAudioFromProject() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("couldn't load file")
        }
    }
    
}
