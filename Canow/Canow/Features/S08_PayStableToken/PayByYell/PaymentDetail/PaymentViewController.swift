//
//  PaymentViewController.swift
//  Canow
//
//  Created by NhanTT13 on 12/27/21.
//

import UIKit
import Kingfisher

class PaymentViewController: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s06TitlePay.localized)
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
    @IBOutlet private weak var useCouponImage: UIImageView! {
        didSet {
            self.useCouponImage.layer.cornerRadius = 7
            self.useCouponImage.layer.borderWidth = 0.5
            self.useCouponImage.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var merchantImage: UIImageView! {
        didSet {
            self.merchantImage.layer.cornerRadius = self.merchantImage.frame.size.width / 2
        }
    }
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentView.backgroundColor = self.themeInfo.bgPattern1 != nil ? .clear : .white
        }
    }
    @IBOutlet weak var ticketView: UIView! {
        didSet {
            self.ticketView.clipsToBounds = true
            self.ticketView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.dropShadow(color: .color0000001F,
                                       opacity: 1,
                                       offSet: CGSize(width: 0, height: 2),
                                       radius: 10)
        }
    }
    @IBOutlet weak var topViewTicket: UIView!
    @IBOutlet weak var nameMerchantLabel: UILabel! {
        didSet {
            self.nameMerchantLabel.font = .font(with: .bold700, size: 14)
            self.nameMerchantLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var merchantTitleLabel: UILabel! {
        didSet {
            self.merchantTitleLabel.text = StringConstants.s06Merchant.localized
            self.merchantTitleLabel.font = .font(with: .medium500, size: 12)
            self.merchantTitleLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            self.errorLabel.font = .font(with: .medium500, size: 12)
            self.errorLabel.textColor = .colorRedEB2727
        }
    }
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.textColor = .colorBlack111111
            self.amountLabel.font = .font(with: .bold700, size: 36)
        }
    }
    @IBOutlet weak var nameCouponLabel: UILabel! {
        didSet {
            self.nameCouponLabel.textColor = .colorBlack111111
            self.nameCouponLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet weak var merchantLabel: UILabel! {
        didSet {
            self.merchantLabel.textColor = .colorBlack111111
            self.merchantLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var amountYellLabel: UILabel! {
        didSet {
            self.amountYellLabel.textColor = .colorBlack111111
            self.amountYellLabel.font = .font(with: .bold700, size: 16)
        }
    }
    @IBOutlet weak var payButton: CustomButton! {
        didSet {
            self.payButton.setTitle(StringConstants.s06BtnPay.localized, for: .normal)
            self.payButton.setTitle(StringConstants.s06BtnPay.localized, for: .highlighted)
            self.payButton.disable()
        }
    }
    @IBOutlet weak var topUpButton: UIButton! {
        didSet {
            self.topUpButton.setTitleColor(self.themeInfo.textColor, for: .normal)
            self.topUpButton.setTitleColor(self.themeInfo.textColor, for: .highlighted)
            self.topUpButton.layer.cornerRadius = 6
            self.topUpButton.setTitle(StringConstants.s04BtnTopup.localized, for: .normal)
            self.topUpButton.setTitle(StringConstants.s04BtnTopup.localized, for: .highlighted)
            self.topUpButton.titleLabel?.font = .font(with: .bold700, size: 16)
        }
    }
    @IBOutlet weak var yellView: UIView! {
        didSet {
            self.yellView.layer.cornerRadius = self.yellView.frame.height / 2
            self.yellView.backgroundColor = .colorE5E5E5.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var titleCouponViewLabel: UILabel! {
        didSet {
            self.titleCouponViewLabel.text = StringConstants.s06UseCoupon.localized
            self.titleCouponViewLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            self.itemNameLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var yellLabel: UILabel!
    @IBOutlet weak var stableTokenImage: UIImageView! {
        didSet {
            self.stableTokenImage.rounded()
        }
    }
    
    // MARK: - Properties
    private let viewModel = PaymentViewModel()
    var coupon: CouponMerchantInfo?
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Method
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension PaymentViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
        if let couponInfo = coupon {
            self.viewModel.getEcouponDetail(eCouponId: couponInfo.eCouponId)
            self.nameCouponLabel.text = couponInfo.couponName
            self.merchantLabel.text = couponInfo.merchantName
            self.amountLabel.text = couponInfo.payPrice.formatPrice()
            if let couponURL = CommonManager.getImageURL(couponInfo.image) {
                self.useCouponImage.kf.setImage(with: couponURL)
            }
        }
        if let merchant = DataManager.shared.getMerchantInfo() {
            if let merchantURL = CommonManager.getImageURL(merchant.logo) {
                self.merchantImage.kf.setImage(with: merchantURL)
            }
            self.nameMerchantLabel.text = merchant.name
            self.headerView.setTitle(title: "\(StringConstants.s06TitlePay.localized) \(merchant.name)")
        }
        
        self.viewModel.getStableTokenCustomer()
        self.viewModel.getStableTokenCustomerMobile()
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = { stableToken in
            self.amountYellLabel.text = "\(stableToken.balance ?? 0)".formatPrice()
            if Int(self.coupon?.payPrice ?? "") ?? 0 > stableToken.balance ?? 0 {
                self.payButton.disable()
                self.errorLabel.text = StringConstants.pleaseTopup.localized
                self.errorLabel.isHidden = false
            } else {
                self.payButton.enable()
                self.errorLabel.isHidden = true
            }
        }
        
        self.viewModel.getStableMobileInfSuccess = {
            if let stableToken = self.viewModel.stableToken {
                self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
                self.yellLabel.text = stableToken.name
            }
        }
        
        self.viewModel.getECouponDetailSuccess = {
            self.itemNameLabel.text = self.viewModel.eCouponInfo?.itemName
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
}

// MARK: - Actions
extension PaymentViewController {
    
    @IBAction func payNowAction(_ sender: CustomButton) {
        if Int(self.coupon?.payPrice ?? "") ?? 0 <= self.amountYellLabel.text?.formatPriceToInt() ?? 0 {
            let transactionConfirmVC = TransactionConfirmViewController(transactionType: .pay)
            transactionConfirmVC.amount = Int(self.coupon?.payPrice ?? "") ?? 0
            transactionConfirmVC.payType = .payDiscountCoupon
            transactionConfirmVC.eCouponInfo = self.viewModel.eCouponInfo
            self.push(viewController: transactionConfirmVC)
        }
    }
    
    @IBAction func topUpAction(_ sender: Any) {
        let topUpVC = TopupViewController()
        self.push(viewController: topUpVC)
    }
    
}
