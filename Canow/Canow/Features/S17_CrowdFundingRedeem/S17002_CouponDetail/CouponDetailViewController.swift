//
//  CouponDetailViewController.swift
//  Canow
//
//  Created by hieplh2 on 06/12/2021.
//
//  Screen ID: S15002

import UIKit

class CouponDetailViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
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
    @IBOutlet private weak var banlanceView: UIView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var balanceImageView: UIImageView! {
        didSet {
            self.balanceImageView.image = {
                if let background = self.themeInfo.bgPattern7 {
                    return background
                } else {
                    return UIImage(named: "bg_balance_remittance")
                }
            }()
        }
    }
    @IBOutlet private weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.textColor = self.themeInfo.textColor
        }
    }
    @IBOutlet private weak var balanceTextLabel: UILabel! {
        didSet {
            self.balanceTextLabel.text = StringConstants.s14Balance.localized
            self.balanceTextLabel.textColor = self.themeInfo.textColor.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var balanceFanTokenLogoImageView: UIImageView! {
        didSet {
            self.balanceFanTokenLogoImageView.rounded()
        }
    }
    
    @IBOutlet private weak var itemRedeemView: ItemRedeemView! {
        didSet {
            self.itemRedeemView.dropShadow()
        }
    }
    
    @IBOutlet private weak var priceRedeemTitleLabel: UILabel! {
        didSet {
            self.priceRedeemTitleLabel.text = StringConstants.s14PriceOfCoupon.localized
        }
    }
    
    @IBOutlet private weak var descriptionTitleLabel: UILabel! {
        didSet {
            self.descriptionTitleLabel.text = StringConstants.s14Description.localized
        }
    }
    
    @IBOutlet private weak var amountPayTitleLabel: UILabel! {
        didSet {
            self.amountPayTitleLabel.text = StringConstants.s15AmounttoPay.localized
        }
    }
    
    @IBOutlet private weak var merchantNameTitleLabel: UILabel! {
        didSet {
            self.merchantNameTitleLabel.text = StringConstants.s06Merchant.localized
        }
    }
    
    @IBOutlet private weak var couponInfoLabel: UILabel! {
        didSet {
            self.couponInfoLabel.text = StringConstants.s14CouponInfor.localized
        }
    }
    
    @IBOutlet private weak var priceImageView: UIImageView! {
        didSet {
            self.priceImageView.rounded()
        }
    }
    
    @IBOutlet weak var priceValueLabel: UILabel!
    
    @IBOutlet private weak var amountPayLabel: UILabel!
    
    @IBOutlet private weak var merchantLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var redeemButton: CustomButton!
    @IBOutlet private weak var priceRedeemImageView: UIImageView! {
        didSet {
            self.priceRedeemImageView.rounded()
        }
    }
    
    // MARK: - Properties
    private let viewModel = CouponDetailViewModel()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    var fantoken: String = ""
    var couponId = ""
    var courseActionType: CourseActionType = .redeem
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override methods
    override func bindViewAndViewModel() {
        self.fetchDataSuccess()
        self.fetchDataFailure()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.redeemButton.setTitle(StringConstants.s17BtnDonateRedeem.localized, for: .normal)
        self.redeemButton.setTitle(StringConstants.s17BtnDonateRedeem.localized, for: .highlighted)
        self.redeemButton.setupUI()
    }
    
}

// MARK: - Methods
extension CouponDetailViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        if KeychainManager.apiIdToken() == nil {
            self.priceRedeemImageView.kf.setImage(with: CommonManager.getImageURL(DataManager.shared.getStableTokenDefault()?.logo))
        } else {
            self.priceRedeemImageView.kf.setImage(with: CommonManager.getImageURL(DataManager.shared.getStableTokenCustomer()?.logo))
        }
        self.itemRedeemView.usableFromTitle = StringConstants.s14UsableFrom.localized
        self.fetchData()
    }
    
    private func fetchData() {
        if KeychainManager.apiIdToken() != nil {
            self.viewModel.getStableTokenCustomer()
        }
        self.banlanceView.isHidden = KeychainManager.apiIdToken() == nil
        self.viewModel.getCourseDetail(couponId: self.couponId)
        guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
            return
        }
        self.viewModel.getCustomerBalance(tokenType: partnerInfo.fantokenTicker)
    }
    
    private func fetchDataSuccess() {
        self.viewModel.getCourseDetailSuccess = { courseDetail in
            self.topImageView.kf.setImage(with: CommonManager.getImageURL(courseDetail.merchantLogo))
            
            self.itemRedeemView.itemImageView.kf.setImage(with: CommonManager.getImageURL(courseDetail.image))
            
            self.itemRedeemView.merchantName = courseDetail.merchantName
            self.itemRedeemView.couponName = courseDetail.couponName
            
            self.itemRedeemView.usableDate = courseDetail.usableFrom.formatDateString()
            self.itemRedeemView.expireDate = courseDetail.expiredDate.formatDateString()
            
            self.itemRedeemView.progressView.total = courseDetail.quantity
            self.itemRedeemView.progressView.current = Int(courseDetail.redeemedQuantity) ?? 0
            self.itemRedeemView.progressView.remaining = Int(courseDetail.remainingQuantity) ?? 0
            
            self.priceValueLabel.text = "\(courseDetail.price)".formatPrice()
            self.balanceFanTokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(self.fantoken))
            self.priceImageView.kf.setImage(with: CommonManager.getImageURL(self.fantoken))
            self.merchantLabel.text = courseDetail.merchantName
            self.descriptionLabel.text = courseDetail.description.htmlToString
            self.amountPayLabel.text = "\(courseDetail.payPrice)".formatPrice()
        }
        
        self.viewModel.fetchFantokenBalanceInfo = { fantokenInfo  in
            if let fanTokenBalance = fantokenInfo?.fanTokenBalance {
                self.balanceLabel.text = "\(fanTokenBalance)".formatPrice()
            }
        }
//        self.viewModel.fetchDataSuccess = { stableTokenCustomer in
//            self.balanceLabel.text = "\(stableTokenCustomer.balance ?? 0)".formatPrice()
//        }
        
        self.viewModel.checkRedeemCourseSuccess = {
            let transactionConfirm = TransactionConfirmViewController(transactionType: .redeemCourse)
            transactionConfirm.fanTokenLogo = self.fantoken
            if let courseDetail = self.viewModel.courseDetailInfo {
                transactionConfirm.course = courseDetail
            }
            self.push(viewController: transactionConfirm)
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.stableTokenCustomerFailure = { _ in
            self.banlanceView.isHidden = true
        }
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            switch error {
            case MessageCode.E032.message:
                self.showPopup(title: StringConstants.s14TitleCouponInactiveNormalRedeem.localized,
                               message: StringConstants.s14RedeemCouponError.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.pop()
                }))
            case MessageCode.E033.message:
                self.showPopup(title: StringConstants.s14TitleSoldOutCrowdfunding.localized,
                               message: StringConstants.s14MessageSoldOutCrowdfunding.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.pop()
                }))
            case MessageCode.E017.message:
                self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                               message: StringConstants.s14Message_ExchangeMore.localized,
                               popupBg: UIImage(named: "bg_yourBalance"),
                               leftButton: (StringConstants.s01BtnCancel.localized, {}),
                               rightButton: (StringConstants.s17BtnExchange.localized, {
                    guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
                        return
                    }
                    let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
                    inputAmountVC.partnerId = partnerInfo.id
                    inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo ?? ""
                    self.push(viewController: inputAmountVC) }))
            case MessageCode.E067.message:
                self.showPopup(title: StringConstants.s14TitleCouponRunOut.localized,
                               message: StringConstants.s14RedeemOtherCoupons.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.pop()
                }))
            case MessageCode.E065.message:
                self.showPopup(title: MessageCode.E065.message,
                               message: StringConstants.s17MessageCheckAgain.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.viewControllers.forEach({ (vc) in
                        if  let homePageViewController = vc as? HomePageViewController {
                            self.popTo(viewController: homePageViewController)
                        }
                    })
                }))
            default:
                break
            }
        }
    }
    
}

// MARK: - Actions
extension CouponDetailViewController {
    
    @IBAction func actionRedeem(_ sender: CustomButton) {
        if !CommonManager.checkLandingPage() {
            return
        }
        self.viewModel.checkRedeemCourse(couponId: self.couponId)
    }
    
}
