//
//  HistoryDetailViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/8/21.
//
//  Screen ID: S20001

import UIKit
import Kingfisher

class HistoryDetailViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s04TitleTransactionDetail.localized)
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
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.backgroundColor = self.themeInfo.bgPattern1 != nil ? .clear : .white
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet private weak var othersView: UIView!
    @IBOutlet private weak var ticketView: UIView! {
        didSet {
            self.ticketView.dropShadow()
        }
    }
    
    @IBOutlet private weak var smartReceiptView: UIView! {
        didSet {
            self.smartReceiptView.backgroundColor = .colorF4F4F4
            self.smartReceiptView.clipsToBounds = true
            self.smartReceiptView.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet private weak var smartReceiptLabel: UILabel! {
        didSet {
            self.smartReceiptLabel.font = .font(with: .medium500, size: 14)
            self.smartReceiptLabel.text = StringConstants.s07SmartReceipt.localized
            self.smartReceiptLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var topUpHistoryView: TopUpHistoryView!
    @IBOutlet private weak var transferHistoryView: TransferHistoryView!
    @IBOutlet private weak var payHistoryView: PayHistoryView!
    @IBOutlet private weak var payWithoutCouponView: PayWithoutCouponView!
    @IBOutlet private weak var remittanceView: RemittanceView!
    @IBOutlet private weak var manualTransferView: ManualTransferView!
    @IBOutlet private weak var airdropRewardView: AirdropRewardView!
    @IBOutlet private weak var airdropUseCouponView: AirdropUseCouponView!
    
    // MARK: - Properties
    private let viewModel = HistoryDetailViewModel()
    var historyInfo: HistoryInfo?
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    var transactionId: String = ""
    
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

// MARK: Methods
extension HistoryDetailViewController {
    
    private func setupUI() {
        self.view.backgroundColor = self.themeInfo.primaryColor
        let tapSmartReceiptView = UITapGestureRecognizer(target: self, action: #selector(tapSmartReceiptView))
        self.smartReceiptView.addGestureRecognizer(tapSmartReceiptView)
        self.othersView.isHidden = true
        if transactionId != "" {
            self.airdropRewardView.isHidden = false
            self.viewModel.getTransactionDetail(transactionId: self.transactionId)
            self.headerView.onBack = {
                self.popToRoot()
                NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
            }
            return
        }
        switch self.historyInfo?.transactionType {
        case .topUp:
            self.topUpHistoryView.isHidden = false
        case .transfer, .exchange:
            self.transferHistoryView.isHidden = false
        case .useCoupon, .useCourse, .useCouponWithoutPayment, .redeemCourse, .redeemCoupon, .useCouponRedEnvelopeEvent:
            self.payHistoryView.isHidden = false
        case .pay:
            self.payWithoutCouponView.isHidden = false
        case .remittance:
            self.remittanceView.isHidden = false
        case .transferSTfromCustomerToOperator, .transferSTfromOperatorToCustomer:
            self.manualTransferView.isHidden = false
        case .transferSTAirdropEvent, .transferSTRedEnvelopeEvent:
            self.airdropRewardView.isHidden = false
        case .useCouponAirdropEvent:
            self.airdropUseCouponView.isHidden = false
        default:
            break
        }
        CommonManager.showLoading()
        self.viewModel.getTransactionDetail(transactionId: self.historyInfo?.transactionId ?? "")
    }
    
    private func setupTopUp() {
        let transactionDetail = self.viewModel.transactionDetail
        if let customerInfo = DataManager.shared.getCustomerInfo() {
            self.topUpHistoryView.customerName = customerInfo.fullname
            self.topUpHistoryView.customerPhone = customerInfo.userName
            self.topUpHistoryView.customerAvatar = customerInfo.avatar ?? ""
            self.topUpHistoryView.amount = transactionDetail?.amount ?? 0
            self.topUpHistoryView.transactionStatus = transactionDetail?.status ?? .pending
            self.topUpHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
            self.topUpHistoryView.giftCode = transactionDetail?.giftCardId ?? ""
            self.topUpHistoryView.transactionId = transactionDetail?.transactionId ?? ""
            self.topUpHistoryView.tokenLogo = transactionDetail?.tokenLogo ?? ""
        }
    }
    
    private func setUpTransfer() {
        let transactionDetail = self.viewModel.transactionDetail
        self.transferHistoryView.amount = transactionDetail?.amount ?? 0
        self.transferHistoryView.transactionStatus = transactionDetail?.status ?? .pending
        self.transferHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
        self.transferHistoryView.transactionId = transactionDetail?.transactionId ?? ""
        self.transferHistoryView.tokenLogo = transactionDetail?.tokenLogo ?? ""
        if !(transactionDetail?.toCustomer?.isEmpty ?? true) {
            let phone = transactionDetail?.toCustomer ?? ""
            self.transferHistoryView.transferTitle = StringConstants.s05LbTransferFrom.localized
            self.viewModel.getReceiverInfo(phoneNumber: phone)
        } else {
            let phone = transactionDetail?.fromCustomer ?? ""
            self.transferHistoryView.transferTitle = StringConstants.s07LbTransferFrom.localized
            self.viewModel.getReceiverInfo(phoneNumber: phone)
        }
        
    }
    
    private func setUpExchange() {
        let transactionDetail = self.viewModel.transactionDetail
        if let customerInfo = DataManager.shared.getCustomerInfo() {
            self.transferHistoryView.customerName = customerInfo.fullname
            self.transferHistoryView.customerPhone = customerInfo.userName
            self.transferHistoryView.customerAvatar = customerInfo.avatar ?? ""
            self.transferHistoryView.amount = transactionDetail?.amount ?? 0
            self.transferHistoryView.transactionStatus = transactionDetail?.status ?? .pending
            self.transferHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
            self.transferHistoryView.transactionId = transactionDetail?.transactionId ?? ""
            self.transferHistoryView.tokenLogo = transactionDetail?.tokenLogo ?? ""
            self.transferHistoryView.transferTitle = StringConstants.s13LbExchangeDetail.localized
            self.transferHistoryView.isHiddenEquivalent = false
            self.viewModel.getStableToken()
        }
    }
    
    private func setUpUseCoupon() {
        let transactionDetail = self.viewModel.transactionDetail
        self.payHistoryView.amount = transactionDetail?.amount ?? 0
        self.payHistoryView.transactionStatus = transactionDetail?.status ?? .pending
        self.payHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
        self.payHistoryView.transactionId = transactionDetail?.transactionId ?? ""
        self.payHistoryView.merchantLogo = transactionDetail?.merchantLogo ?? ""
        self.payHistoryView.merchantName = transactionDetail?.merchantName ?? ""
        self.payHistoryView.merchantNameCoupon = transactionDetail?.merchantName ?? ""
        self.payHistoryView.itemName = transactionDetail?.itemName ?? ""
        self.payHistoryView.couponLogo = transactionDetail?.couponImage ?? ""
        self.payHistoryView.couponName = transactionDetail?.couponName ?? ""
        self.payHistoryView.transactionTitle = StringConstants.s07LbUsedCoupon.localized
        self.viewModel.getStableToken()
    }
    
    private func setupRedeemCourse() {
        let transactionDetail = self.viewModel.transactionDetail
        self.payHistoryView.amount = transactionDetail?.amount ?? 0
        self.payHistoryView.transactionStatus = transactionDetail?.status ?? .pending
        self.payHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
        self.payHistoryView.transactionId = transactionDetail?.transactionId ?? ""
        self.payHistoryView.merchantLogo = transactionDetail?.merchantLogo ?? ""
        self.payHistoryView.merchantName = transactionDetail?.merchantName ?? ""
        self.payHistoryView.itemName = transactionDetail?.itemName ?? ""
        self.payHistoryView.couponLogo = transactionDetail?.couponImage ?? ""
        self.payHistoryView.couponName = transactionDetail?.couponName ?? ""
        self.payHistoryView.stableTokenLogo = transactionDetail?.tokenLogo ?? ""
        self.payHistoryView.isHiddenCampaginName = false
        self.payHistoryView.campaginName = transactionDetail?.campaignName ?? ""
        self.payHistoryView.teamName = transactionDetail?.teamName ?? ""
        self.payHistoryView.merchantLogo = transactionDetail?.teamLogo ?? ""
        self.payHistoryView.merchantTitle = StringConstants.s07TitleTeam.localized
        self.payHistoryView.transactionTitle = StringConstants.s07LbRedeemedCoupon.localized
    }
    
    private func setupRedeemCoupon() {
        let transactionDetail = self.viewModel.transactionDetail
        self.payHistoryView.amount = transactionDetail?.amount ?? 0
        self.payHistoryView.transactionStatus = transactionDetail?.status ?? .pending
        self.payHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
        self.payHistoryView.transactionId = transactionDetail?.transactionId ?? ""
        self.payHistoryView.merchantName = transactionDetail?.merchantName ?? ""
        self.payHistoryView.itemName = transactionDetail?.itemName ?? ""
        self.payHistoryView.couponLogo = transactionDetail?.couponImage ?? ""
        self.payHistoryView.couponName = transactionDetail?.couponName ?? ""
        self.payHistoryView.stableTokenLogo = transactionDetail?.tokenLogo ?? ""
        self.payHistoryView.teamName = transactionDetail?.teamName ?? ""
        if transactionDetail?.teamLogo == "" {
            self.payHistoryView.merchantLogo = transactionDetail?.merchantLogo ?? ""
        } else {
            self.payHistoryView.merchantLogo = transactionDetail?.teamLogo ?? ""
        }
        self.payHistoryView.merchantTitle = StringConstants.s07TitleTeam.localized
        self.payHistoryView.transactionTitle = StringConstants.s07LbRedeemedCoupon.localized
    }
    
    private func setupPay() {
        let transactionDetail = self.viewModel.transactionDetail
        self.payWithoutCouponView.amount = transactionDetail?.amount ?? 0
        self.payWithoutCouponView.transactionStatus = transactionDetail?.status ?? .pending
        self.payWithoutCouponView.transactionDate = transactionDetail?.createdAt ?? ""
        self.payWithoutCouponView.transactionId = transactionDetail?.transactionId ?? ""
        self.payWithoutCouponView.merchantLogo = transactionDetail?.merchantLogo ?? ""
        self.payWithoutCouponView.merchantName = transactionDetail?.merchantName ?? ""
        self.payWithoutCouponView.stableTokenLogo = transactionDetail?.tokenLogo ?? ""
    }
    
    private func setupRemittance() {
        let transactionDetail = self.viewModel.transactionDetail
        self.remittanceView.amount = transactionDetail?.amount ?? 0
        self.remittanceView.transactionStatus = transactionDetail?.status ?? .pending
        self.remittanceView.transactionDate = transactionDetail?.createdAt ?? ""
        self.remittanceView.transactionId = transactionDetail?.transactionId ?? ""
        self.remittanceView.purchasedLogo = transactionDetail?.campaignItemLogo ?? ""
        self.remittanceView.purchasedName = transactionDetail?.campaignItemName ?? ""
        self.remittanceView.teamName = transactionDetail?.teamName ?? ""
        self.remittanceView.teamLogo = transactionDetail?.teamLogo ?? ""
        self.remittanceView.campaignName = transactionDetail?.campaignName ?? ""
        self.remittanceView.stableTokenLogo = transactionDetail?.tokenLogo ?? ""
    }
    
    private func setupManualTransfer() {
        let transactionDetail = self.viewModel.transactionDetail
        self.manualTransferView.amount = transactionDetail?.amount ?? 0
        self.manualTransferView.imageST = transactionDetail?.tokenLogo ?? ""
        self.manualTransferView.transactionDate = transactionDetail?.createdAt ?? ""
        self.manualTransferView.transactionId = transactionDetail?.transactionId ?? ""
        self.manualTransferView.messageReason = transactionDetail?.reason ?? ""
        self.manualTransferView.adminName = StringConstants.yelltumAdmin.localized
        self.manualTransferView.adminTitle = StringConstants.adjustByAdmin.localized
    }
    
    private func setupAirdropReward() {
        let transactionDetail = self.viewModel.transactionDetail
        self.airdropRewardView.amount = transactionDetail?.amount ?? 0
        self.airdropRewardView.imageST = transactionDetail?.tokenLogo ?? ""
        self.airdropRewardView.transactionDate = transactionDetail?.createdAt ?? ""
        self.airdropRewardView.transactionId = transactionDetail?.transactionId ?? ""
        self.airdropRewardView.messageReason = transactionDetail?.reason ?? ""
        self.airdropRewardView.eventName = transactionDetail?.eventName ?? ""
        self.airdropRewardView.transactionStatus = transactionDetail?.status ?? .pending
    }
    
    private func setupAirdropUseCoupon() {
        let transactionDetail = self.viewModel.transactionDetail
        self.airdropUseCouponView.amount = transactionDetail?.amount ?? 0
        self.airdropUseCouponView.imageST = transactionDetail?.tokenLogo ?? ""
        self.airdropUseCouponView.transactionDate = transactionDetail?.createdAt ?? ""
        self.airdropUseCouponView.transactionId = transactionDetail?.transactionId ?? ""
        self.airdropUseCouponView.reason = transactionDetail?.reason ?? ""
        self.airdropUseCouponView.eventName = transactionDetail?.eventName ?? ""
        self.airdropUseCouponView.merchantName = transactionDetail?.merchantName ?? ""
        self.airdropUseCouponView.couponName = transactionDetail?.couponName ?? ""
        self.airdropUseCouponView.itemName = transactionDetail?.itemName ?? ""
        self.airdropUseCouponView.imageCoupon = transactionDetail?.couponImage ?? ""
        self.airdropUseCouponView.imageTeam = transactionDetail?.teamLogo ?? ""
        self.airdropUseCouponView.transactionStatus = transactionDetail?.status ?? .pending
    }
    
    private func setUpUseCouponRedEnvelope() {
        let transactionDetail = self.viewModel.transactionDetail
        self.payHistoryView.amount = transactionDetail?.amount ?? 0
        self.payHistoryView.transactionStatus = transactionDetail?.status ?? .pending
        self.payHistoryView.transactionDate = transactionDetail?.createdAt ?? ""
        self.payHistoryView.transactionId = transactionDetail?.transactionId ?? ""
        self.payHistoryView.merchantLogo = transactionDetail?.teamLogo ?? ""
        self.payHistoryView.merchantName = transactionDetail?.teamName ?? ""
        self.payHistoryView.itemName = transactionDetail?.itemName ?? ""
        self.payHistoryView.couponLogo = transactionDetail?.couponImage ?? ""
        self.payHistoryView.couponName = transactionDetail?.couponName ?? ""
        self.payHistoryView.campaginName = transactionDetail?.eventName ?? ""
        self.payHistoryView.merchantNameTitle = transactionDetail?.merchantName ?? ""
        self.payHistoryView.transactionTitle = StringConstants.s07LbUsedCoupon.localized
        self.payHistoryView.teamTitle = StringConstants.s07LbTeam.localized
        self.viewModel.getStableToken()
    }
    
    private func setupTransferSTRedEnvelope() {
        let transactionDetail = self.viewModel.transactionDetail
        self.airdropRewardView.amount = transactionDetail?.amount ?? 0
        self.airdropRewardView.imageST = transactionDetail?.tokenLogo ?? ""
        self.airdropRewardView.transactionDate = transactionDetail?.createdAt ?? ""
        self.airdropRewardView.transactionId = transactionDetail?.transactionId ?? ""
        self.airdropRewardView.messageReason = transactionDetail?.reason ?? ""
        self.airdropRewardView.eventName = transactionDetail?.eventName ?? ""
        self.airdropRewardView.lineView.isHidden = true
        self.airdropRewardView.messageView.isHidden = true
        self.airdropRewardView.transactionStatus = transactionDetail?.status ?? .pending
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
            if self.transactionId != "" {
                self.setupTransferSTRedEnvelope()
                return
            }
            switch self.historyInfo?.transactionType {
            case .topUp:
                self.setupTopUp()
            case .transfer:
                self.setUpTransfer()
            case .exchange:
                self.setUpExchange()
            case .useCoupon, .useCourse, .useCouponWithoutPayment:
                self.setUpUseCoupon()
            case .redeemCourse:
                self.setupRedeemCourse()
            case .redeemCoupon:
                self.setupRedeemCoupon()
            case .pay:
                self.setupPay()
            case .remittance:
                self.setupRemittance()
            case .transferSTfromCustomerToOperator, .transferSTfromOperatorToCustomer:
                self.setupManualTransfer()
            case .transferSTAirdropEvent:
                self.setupAirdropReward()
            case .useCouponAirdropEvent:
                self.setupAirdropUseCoupon()
            case .useCouponRedEnvelopeEvent:
                self.setUpUseCouponRedEnvelope()
            case .transferSTRedEnvelopeEvent:
                self.setupTransferSTRedEnvelope()
            default:
                break
            }
        }
        
        self.viewModel.fetchReceiverInfoSuccess = {
            let receiver = self.viewModel.receiverInfo
            self.transferHistoryView.customerName = receiver?.fullname ?? ""
            self.transferHistoryView.customerAvatar = receiver?.avatar ?? ""
            self.transferHistoryView.customerPhone = receiver?.userName ?? ""
        }
        
        self.viewModel.fetchStableTokenSuccess = {
            self.transferHistoryView.stableTokenLogo = self.viewModel.stableToken?.logo ?? ""
            self.payHistoryView.stableTokenLogo = self.viewModel.stableToken?.logo ?? ""
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
    
}

// MARK: - Actions
extension HistoryDetailViewController {
    
    @objc func tapSmartReceiptView(_ sender: UITapGestureRecognizer) {
        self.push(viewController: SmartReceiptViewController())
    }
    
}
