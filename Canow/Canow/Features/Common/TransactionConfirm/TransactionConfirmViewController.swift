//
//  TransactionConfirmViewController.swift
//  Canowz1
//
//  Created by NhiVHY on 1/5/22.
//

import UIKit

enum PayType: CaseIterable {
    case payDiscountCoupon, payWithoutCoupon, payPremoney
}

class TransactionConfirmViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s04TitleTransactionDetail.localized)
            self.headerView.backButtonHidden = false
            self.headerView.onBack = {
                self.pop()
            }   
        }
    }
    @IBOutlet weak var bgImageView: UIImageView! {
        didSet {
            self.bgImageView.image = self.themeInfo.bgPattern2
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentView.backgroundColor = self.themeInfo.bgPattern1 == nil ? .white : .clear
        }
    }
    @IBOutlet private weak var ticketView: UIView! {
        didSet {
            self.ticketView.dropShadow(color: .color0000001F,
                                       opacity: 1,
                                       offSet: CGSize(width: 0, height: 2),
                                       radius: 10)
            self.ticketView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var confirmButton: CustomButton! {
        didSet {
            self.confirmButton.layer.cornerRadius = 6
            self.confirmButton.setTitle(StringConstants.s04BtnConfirm.localized, for: .normal)
            self.confirmButton.setTitle(StringConstants.s04BtnConfirm.localized, for: .highlighted)
            self.confirmButton.setupUI()
        }
    }
    @IBOutlet weak var redeemCouponView: RedeemCouponConfirmView!
    @IBOutlet weak var useCouponView: UseCouponConfirmView!
    @IBOutlet weak var remittanceCampaignView: RemittanceCampaignConfirmView!
    @IBOutlet weak var transferConfirmView: TransferConfirmView!
    @IBOutlet weak var exchangeView: ExchangeConfirmView!
    
    // MARK: - Properties
    private let viewModel = TransactionConfirmViewModel()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    var amount: Int = 0
    var amountPay = ""
    var merchantId: Int = 0
    var merchantName: String = ""
    var merchantImage: String = ""
    var payType: PayType  = .payWithoutCoupon
    var coupon: CouponMerchantInfo?
    var course: CourseDetailInfo?
    var eCouponInfo: EcouponInfo?
    var eCouponId: String = ""
    var transactionId: String = ""
    var transactionType: TransactionType = .redeemCourse
    var couponDetail: CouponDetailInfo?
    var fanTokenLogo: String = ""
    var fanTokenType: String = ""
    var remittanceToAvatar: String = ""
    var remittanceItemAmount: Int = 0
    var remittanceItemName: String = ""
    var remittanceNameLabel: String = ""
    var remittanceCampaignId: Int = 0
    var remittanceCampaignItemId: Int = 0
    var transferType: TransferType = .transferStableToken
    // Exchange
    var partnerId: Int = 0
    var amountExchange: Int = 0
    var imageSTExchange: String = ""
    var balanceUserExchange: Int = 0
    var cellSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
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
        self.inputAmountPayBySBSuccess()
        self.transactionExchangeFailure()
    }
    
}

// MARK: - Methods
extension TransactionConfirmViewController {
    
    func inputAmountPayBySBSuccess() {
        self.viewModel.inputAmountPayBySTSuccess = { transactionId in
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.merchantName = self.merchantName
            viewController.merchantImageProperties = self.merchantImage
            viewController.transactionType = .pay
            viewController.payType = self.payType
            self.push(viewController: viewController)
            CommonManager.hideLoading()
        }
    }
    
    private func setupUI() {
        switch transactionType {
        case .transfer:
            self.setupTransfer()
        case .pay:
            self.setupPayView()
        case .redeemCoupon:
            self.setupRedeemCoupon()
        case .redeemCourse:
            self.setupRedeemCourse()
        case .useCoupon, .useCouponRedEnvelopeEvent, .useCouponAirdropEvent:
            self.setupUseCoupon()
        case .remittance:
            self.setupRemittanceCampaign()
        case .exchange:
            self.setupExchangeView()
        default:
            break
        }
    }
    
    private func setupExchangeView() {
        self.redeemCouponView.isHidden = true
        self.useCouponView.isHidden = true
        self.exchangeView.isHidden = false
        
        guard let sender = DataManager.shared.getCustomerInfo() else { return }
        self.exchangeView.imageFT = self.fanTokenLogo
        self.exchangeView.amountExchange = self.amountExchange
        self.exchangeView.userImage = sender.avatar ?? ""
        self.exchangeView.userName = sender.fullname
        self.exchangeView.userPhone = sender.userName
        self.exchangeView.imageST = self.imageSTExchange
        self.exchangeView.balanceUser = self.amountExchange
    }
    
    private func setupTransfer() {
        self.redeemCouponView.isHidden = true
        self.transferConfirmView.isHidden = false
        switch self.transferType {
        case .transferStableToken:
            if let stableToken = DataManager.shared.getStableTokenCustomer() {
                self.transferConfirmView.logoTokenImageView.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            }
        case .transferFantoken:
            self.transferConfirmView.logoTokenImageView.kf.setImage(with: CommonManager.getImageURL(self.fanTokenLogo))
        }
        self.transferConfirmView.amount = self.amount
        if let sender = DataManager.shared.getCustomerInfo(),
           let receiver = DataManager.shared.getReceiverInfo() {
            self.transferConfirmView.fromName = sender.fullname
            self.transferConfirmView.fromPhone = sender.userName
            self.transferConfirmView.fromAvatarURL = sender.avatar ?? ""
            self.transferConfirmView.toName = receiver.name ?? ""
            self.transferConfirmView.toPhone = receiver.phone ?? ""
            self.transferConfirmView.toAvatarURL = receiver.avatar ?? ""
        }
    }
    
    private func setupPayView() {
        self.useCouponView.setup(transactionType: .pay, payType: self.payType)
        self.useCouponView.amount = amount
        
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.useCouponView.imageST = stableToken.logo
        }
        
        if let merchant = DataManager.shared.getMerchantInfo() {
            self.useCouponView.merchantName = merchant.name
            self.merchantImage = merchant.logo
            self.useCouponView.merchantImageURL = merchant.logo
        }
        
        switch self.payType {
        case .payWithoutCoupon, .payPremoney:
            self.redeemCouponView.isHidden = true
            self.useCouponView.isHidden = false
            self.exchangeView.isHidden = true
            
        case .payDiscountCoupon:
            self.redeemCouponView.isHidden = true
            self.useCouponView.isHidden = false
            self.exchangeView.isHidden = true
            
            if let eCouponInfo = self.eCouponInfo {
                self.useCouponView.couponImageURL = eCouponInfo.image
                self.useCouponView.merchantName = eCouponInfo.merchantName
                self.useCouponView.couponName = eCouponInfo.couponName
                self.useCouponView.itemName = eCouponInfo.itemName
            }
        }
    }
    
    private func reloadData() {
        self.viewModel.transactionSuccess = { transactionID in
            CommonManager.hideLoading()
            let transactionStatusViewController = TransactionStatusViewController()
            transactionStatusViewController.fanTokenLogo = self.fanTokenLogo
            transactionStatusViewController.transactionType = .transfer
            transactionStatusViewController.transferType = self.transferType
            transactionStatusViewController.transactionId = transactionID.data.stringValue
            self.push(viewController: transactionStatusViewController)
        }
        
        self.viewModel.payWithCouponSuccess = { transactionId in
            CommonManager.hideLoading()
            let transactionStatusViewController = TransactionStatusViewController()
            transactionStatusViewController.transactionType = .pay
            transactionStatusViewController.transactionId = transactionId
            transactionStatusViewController.eCouponInfo = self.eCouponInfo
            transactionStatusViewController.payType = .payDiscountCoupon
            self.push(viewController: transactionStatusViewController)
        }
        
        self.viewModel.redeemSuccess = { transactionId in
            CommonManager.hideLoading()
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.transactionType = .redeemCourse
            viewController.teamFantokenTickerRedeem = self.course?.teamFantokenTicker ?? ""
            viewController.courseDetail = self.course
            viewController.fanTokenLogo = self.fanTokenLogo
            self.push(viewController: viewController)
        }
        
        self.viewModel.donateSuccess = { transactionId in
            CommonManager.hideLoading()
            let viewController = TransactionStatusViewController()
            viewController.fanTokenLogo = self.fanTokenLogo
            viewController.remittanceToAvatar = self.remittanceToAvatar
            viewController.remittanceItemAmount = self.remittanceItemAmount
            viewController.remittanceItemName = self.remittanceItemName
            viewController.remittanceNameLabel = self.remittanceNameLabel
            viewController.transactionId = transactionId
            viewController.transactionType = .remittance
            self.push(viewController: viewController)
        }
        
        self.viewModel.redeemCouponSuccess = { transactionId in
            CommonManager.hideLoading()
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.transactionType = .redeemCoupon
            viewController.teamFantokenTickerRedeem = self.couponDetail?.teamFantokenTicker ?? ""
            viewController.couponDetail = self.couponDetail
            viewController.fanTokenLogo = self.fanTokenLogo
            self.push(viewController: viewController)
        }
        
        self.viewModel.useCouponsuccess = { transactionId in
            CommonManager.hideLoading()
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.transactionType = .useCoupon
            viewController.couponDetail = self.couponDetail
            viewController.merchantId = self.merchantId
            viewController.fanTokenLogo = self.fanTokenLogo
            self.push(viewController: viewController)
        }

        self.viewModel.fetchDataExchangeSuccess = { transactionId in
            let transactionStatusVC = TransactionStatusViewController()
            let surplusBalance = self.balanceUserExchange - self.amountExchange
            transactionStatusVC.transactionId = transactionId
            transactionStatusVC.transactionType = .exchange
            transactionStatusVC.amountExchange = self.amountExchange
            transactionStatusVC.imageFT = self.fanTokenLogo
            transactionStatusVC.imageST = self.imageSTExchange
            transactionStatusVC.surplusBalance = surplusBalance
            self.push(viewController: transactionStatusVC)
        }
        
        self.viewModel.useCouponRedEnvelopeSusccess = { transactionId in
            CommonManager.hideLoading()
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.transactionType = .useCouponRedEnvelopeEvent
            viewController.couponDetail = self.couponDetail
            viewController.merchantId = self.merchantId
            viewController.fanTokenLogo = self.fanTokenLogo
            self.push(viewController: viewController)
        }
        
        self.viewModel.useCouponAirdropSuccess = { transactionId in
                CommonManager.hideLoading()
                let viewController = TransactionStatusViewController()
                viewController.transactionId = transactionId
                viewController.transactionType = .useCouponAirdropEvent
                viewController.couponDetail = self.couponDetail
                viewController.merchantId = self.merchantId
                viewController.fanTokenLogo = self.fanTokenLogo
                self.push(viewController: viewController)
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            self.showPopup(title: StringConstants.s17MessageErrorConfirm.localized,
                           message: StringConstants.pleaseTryAgain.localized,
                           popupBg: UIImage(named: "bg_failed_tiny"),
                           rightButton: (StringConstants.s01BtnBack.localized, {
                self.dismiss(animated: true, completion: nil)
                self.backToTeamPage() }))
        }
    }
    
    private func backToTeamPage() {
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
    
    private func setupRedeemCoupon() {
        self.redeemCouponView.isHidden = false
        self.useCouponView.isHidden = true
        self.remittanceCampaignView.isHidden = true
        self.redeemCouponView.amount = self.amount
        self.redeemCouponView.balanceImageURL = self.fanTokenLogo
        self.redeemCouponView.couponImageURL = self.couponDetail?.image ?? ""
        self.redeemCouponView.merchantName = self.couponDetail?.merchantName ?? ""
        self.redeemCouponView.couponName = self.couponDetail?.couponName ?? ""
        self.redeemCouponView.itemName = self.couponDetail?.itemName ?? ""
    }
    
    private func setupRedeemCourse() {
        self.redeemCouponView.isHidden = false
        self.useCouponView.isHidden = true
        self.redeemCouponView.amount = self.course?.price ?? 0
        self.redeemCouponView.balanceImageURL = self.fanTokenLogo
        self.redeemCouponView.couponImageURL = self.course?.image ?? ""
        self.redeemCouponView.merchantName = self.course?.merchantName ?? ""
        self.redeemCouponView.couponName = self.course?.couponName ?? ""
        self.redeemCouponView.itemName = "\(StringConstants.s17LbExpiryDate.localized) \(self.course?.expiredDate.formatDateString() ?? "")"
        self.redeemCouponView.usableFrom = "\(StringConstants.s17LbUsableFrom.localized) \(self.course?.usableFrom.formatDateString() ?? "")"
    }
    
    private func setupUseCoupon() {
        self.redeemCouponView.isHidden = true
        self.useCouponView.isHidden = false
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.useCouponView.imageST = stableToken.logo
        }
        self.useCouponView.amount = self.amount
        self.useCouponView.couponImageURL = self.couponDetail?.image ?? ""
        self.useCouponView.merchantImageURL = self.couponDetail?.merchantLogo ?? ""
        self.useCouponView.merchantName = self.couponDetail?.merchantName ?? ""
        self.useCouponView.couponName = self.couponDetail?.couponName ?? ""
        self.useCouponView.itemName = self.couponDetail?.itemName ?? ""
    }
    
    private func setupRemittanceCampaign() {
        self.redeemCouponView.isHidden = true
        self.useCouponView.isHidden = true
        self.remittanceCampaignView.isHidden = false
        self.remittanceCampaignView.imageFantoken = self.fanTokenLogo
        self.remittanceCampaignView.balanceCampaign = "\(self.remittanceItemAmount)"
        self.remittanceCampaignView.avatarImageItem = self.remittanceToAvatar
        self.remittanceCampaignView.nameItem = self.remittanceItemName
        self.remittanceCampaignView.nameCampaign = self.remittanceNameLabel
    }
    
    private func payAction() {
        CommonManager.showLoading()
        switch self.payType {
        case .payDiscountCoupon:
            if let eCouponInfo = self.eCouponInfo, let merchant = DataManager.shared.getMerchantInfo() {
                self.viewModel.payWithCoupon(partnerId: merchant.id, ecouponId: eCouponInfo.eCouponId)
            }
        case .payWithoutCoupon, .payPremoney:
            if let merchant = DataManager.shared.getMerchantInfo() {
                self.viewModel.payByST(partnerId: merchant.id, amount: self.amount)
            }
        }
    }
    
    private func redeemCouponAction() {
        self.viewModel.couponRedeem(eCouponId: self.couponDetail?.couponId ?? "")
    }
    
    private func transactionExchangeFailure() {
        self.viewModel.transactionExchangeFailure = { error in
            CommonManager.hideLoading()
            switch error {
            case MessageCode.E017.message:
                self.showPopup(title: MessageCode.E065.message,
                               message: StringConstants.ERROR_CODE_065.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, { self.pop() }))
            case MessageCode.E020.message:
                self.showPopup(title: MessageCode.E065.message,
                               message: StringConstants.ERROR_CODE_065.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, { self.pop() }))
            case MessageCode.E028.message:
                let transactionStatusViewController = TransactionStatusViewController()
                transactionStatusViewController.amountExchange = self.amountExchange
                transactionStatusViewController.transactionType = .exchange
                transactionStatusViewController.fanTokenLogo = self.fanTokenLogo
                self.push(viewController: transactionStatusViewController)
            default:
                break
            }
        }
    }
    
    private func transferAction() {
        if let phone = DataManager.shared.getReceiverInfo()?.phone {
            switch self.transferType {
            case .transferStableToken:
                CommonManager.showLoading()
                self.viewModel.transferStableToken(amount: amount, receiver: phone)
            case .transferFantoken:
                self.viewModel.transferFantoken(amount: amount, receiver: phone, tokenType: self.fanTokenType)
            }
            
        }
        
    }
    
    private func remittanceAction() {
        self.viewModel.getAndCheckCampaignItem()
        self.viewModel.fetchRemittanceItemWhenDonateSuccess = { remittanceItemData in
            guard let index = self.cellSelectedIndex else {
                return
            }
            let priceChange = remittanceItemData[index].price
            if priceChange == self.remittanceItemAmount {
                self.viewModel.donateNow(campaignId: self.remittanceCampaignId, campaignItemId: self.remittanceCampaignItemId)
            } else {
                self.showPopup(title: StringConstants.s17MessageErrorConfirm.localized,
                               message: StringConstants.pleaseTryAgain.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s01BtnBack.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.backToTeamPage() }))
            }
        }
    }
    
}

// MARK: - Actions
extension TransactionConfirmViewController {
    
    @IBAction func confirmAction(_ sender: UIButton!) {
        switch transactionType {
        case .transfer:
            self.transferAction()
        case .pay:
            self.payAction()
        case .redeemCoupon:
            self.redeemCouponAction()
        case .redeemCourse:
            CommonManager.showLoading()
            if let couponId = self.course?.couponId {
                self.viewModel.redeemCourse(couponId: couponId)
            }
        case .useCoupon:
            CommonManager.showLoading()
            self.viewModel.couponUse(partnerId: self.merchantId, ecouponId: self.eCouponId)
        case .remittance:
            self.remittanceAction()
        case .exchange:
            CommonManager.showLoading()
            self.viewModel.amountExchange(partnerId: self.partnerId, amount: self.amountExchange)
        case .useCouponRedEnvelopeEvent:
            self.viewModel.couponRedEnvelopeUse(partnerId: self.merchantId, ecouponId: self.eCouponId)
        case .useCouponAirdropEvent:
            self.viewModel.couponAirdropUse(partnerId: self.merchantId, ecouponId: self.eCouponId)
        default:
            break
        }
    }

}
