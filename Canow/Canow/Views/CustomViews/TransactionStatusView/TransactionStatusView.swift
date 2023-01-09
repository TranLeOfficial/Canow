//
//  RedeemCouponStatusView.swift
//  Canow
//
//  Created by Nhi Vo on 19/01/2022.
//

import UIKit

class TransactionStatusView: UIView {
    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var statusImageView: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
        }
    }
    @IBOutlet private weak var yellImageView: UIImageView! {
        didSet {
            self.yellImageView.layer.cornerRadius = self.yellImageView.frame.size.height/2
        }
    }
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var redeemedLabel: UILabel! {
        didSet {
            self.redeemedLabel.font = .font(with: .medium500, size: 12)
            self.redeemedLabel.text = StringConstants.s14UsedCoupon.localized
        }
    }
    @IBOutlet private weak var couponImageView: UIImageView! {
        didSet {
            self.couponImageView.layer.cornerRadius = 6
            self.couponImageView.layer.borderWidth = 1
            self.couponImageView.layer.borderColor = UIColor.colorE5E5E5.cgColor
        }
    }
    @IBOutlet private weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var itemNameLabel: UILabel! {
        didSet {
            self.itemNameLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var merchantTextLabel: UILabel! {
        didSet {
            self.merchantTextLabel.font =  .font(with: .medium500, size: 12)
            self.merchantTextLabel.text = StringConstants.s06Merchant.localized
        }
    }
    @IBOutlet private weak var merchantImageView: UIImageView! {
        didSet {
            self.merchantImageView.rounded()
        }
    }
    @IBOutlet private weak var merchantNameLabel2: UILabel! {
        didSet {
            self.merchantNameLabel2.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet private weak var couponView: UIView!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var merchantView: UIView!
    @IBOutlet private weak var usableFromLabel: UILabel! {
        didSet {
            self.usableFromLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private weak var detailTitleLabel: UILabel! {
        didSet {
            self.detailTitleLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var mainDetailLabel: UILabel! {
        didSet {
            self.mainDetailLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet private weak var subDetailLabel: UILabel! {
        didSet {
            self.subDetailLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var equivalentView: UIStackView!
    @IBOutlet private weak var equivalentLabel: UILabel! {
        didSet {
            self.equivalentLabel.font = .font(with: .medium500, size: 12)
            self.equivalentLabel.text = StringConstants.s04EquivalentTo.localized
        }
    }
    @IBOutlet private weak var valueImageView: UIImageView! {
        didSet {
            self.valueImageView.rounded()
        }
    }
    @IBOutlet private weak var valueLabel: UILabel! {
        didSet {
            self.valueLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var detailImageView: UIImageView! {
        didSet {
            self.detailImageView.layer.cornerRadius = self.detailImageView.frame.size.height/2
        }
    }
    
    // MARK: - Properties
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = String(self.amount).formatPrice()
        }
    }
    var fanTokenLogo: String = "" {
        didSet {
            self.yellImageView.kf.setImage(with: CommonManager.getImageURL(self.fanTokenLogo))
        }
    }
    var date: String = "" {
        didSet {
            self.dateLabel.text = self.date
        }
    }
    var couponImageUrl: String = "" {
        didSet {
            self.couponImageView.kf.setImage(with: CommonManager.getImageURL(self.couponImageUrl))
        }
    }
    var merchantName: String = "" {
        didSet {
            self.merchantNameLabel.text = self.merchantName
        }
    }
    var couponName: String = "" {
        didSet {
            self.couponNameLabel.text = self.couponName
        }
    }
    var itemName: String = "" {
        didSet {
            self.itemNameLabel.text = self.itemName
        }
    }
    var merchantImageUrl: String = "" {
        didSet {
            self.merchantImageView.kf.setImage(with: CommonManager.getImageURL(self.merchantImageUrl))
        }
    }
    var usableFrom: String = "" {
        didSet {
            self.usableFromLabel.text = self.usableFrom
        }
    }
    var merchantName2: String = "" {
        didSet {
            self.merchantNameLabel2.text = self.merchantName2
        }
    }
    var maintDetal: String = "" {
        didSet {
            self.mainDetailLabel.text = maintDetal
        }
    }
    var subDetail: String = "" {
        didSet {
            self.subDetailLabel.text = subDetail
        }
    }
    var priceValue: String = "" {
        didSet {
            self.valueLabel.text = self.priceValue
        }
    }
    var detailImageUrl: String = "" {
        didSet {
            if detailImageUrl == "" {
                self.detailImageView.image = UIImage(named: "ic_avatar")
            } else {
                self.detailImageView.kf.setImage(with: CommonManager.getImageURL(self.detailImageUrl))
            }
        }
    }
    var stableTokenLogo: String = "" {
        didSet {
            self.valueImageView.kf.setImage(with: CommonManager.getImageURL(stableTokenLogo))
        }
    }
    var status: String = "" {
        didSet {
            self.statusLabel.textColor = .colorRedEB2727
            self.statusLabel.text = status
            self.statusImageView.image = UIImage(named: "bg_failed_transaction")
        }
    }
    
    // MARK: - Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
}

// MARK: - Init
extension TransactionStatusView {
    private func commonInit() {
        Bundle.main.loadNibNamed("TransactionStatusView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
}

// MARK: - Methods
extension TransactionStatusView {
    
    func handleTransactionStatus(status: TransactionStatus) {
        switch status {
        case .completed:
            self.statusImageView.image = UIImage(named: "bg_success_transaction")
            self.statusLabel.text = StringConstants.s04TransactionSuccess.localized
            self.statusLabel.textColor = .color339A06
        case .failed:
            self.statusImageView.image = UIImage(named: "bg_failed_transaction")
            self.statusLabel.text = StringConstants.s04TransactionFail.localized
            self.statusLabel.textColor = .colorRedEB2727
        case .pending:
            break
        }
    }
    
    func setup(transactionType: TransactionType, payType: PayType = .payDiscountCoupon) {
        switch transactionType {
        case .redeemCoupon:
            self.setupRedeemCoupon()
        case .redeemCourse:
            self.setupRedeemCourse()
        case .pay:
            self.setupPay(payType: payType)
        case .topUp:
            self.setupTopup()
        case .exchange:
            self.setupExchange()
        case .transfer:
            self.setupTransfer()
        case .remittance:
            self.setupRemittance()
        case .useCoupon:
            self.setupUseCoupon()
        default:
            break
        }
    }
    
    private func setupRedeemCoupon() {
        self.lineView.isHidden = true
        self.merchantView.isHidden = true
        self.detailView.isHidden = true
        self.redeemedLabel.text = StringConstants.s14RedeemedCoupon.localized
    }
    
    private func setupRedeemCourse() {
        self.lineView.isHidden = true
        self.merchantView.isHidden = true
        self.detailView.isHidden = true
        self.redeemedLabel.text = StringConstants.s14RedeemedCoupon.localized
        self.usableFromLabel.isHidden = false
    }
    
    private func setupPay(payType: PayType) {
        self.detailView.isHidden = true
        switch payType {
        case .payWithoutCoupon, .payPremoney:
            self.couponView.isHidden = true
            self.lineView.isHidden = true
            self.detailView.isHidden = true
        default:
            self.detailView.isHidden = true
        }
    }
    
    private func setupTopup() {
        self.detailView.isHidden = false
        self.equivalentView.isHidden = false
        self.lineView.isHidden = true
        self.merchantView.isHidden = true
        self.couponView.isHidden = true
        self.valueImageView.isHidden = true
        self.detailTitleLabel.text = StringConstants.topUpDetail.localized
    }
    
    private func setupExchange() {
        self.detailView.isHidden = false
        self.equivalentView.isHidden = false
        self.lineView.isHidden = true
        self.merchantView.isHidden = true
        self.couponView.isHidden = true
        self.valueImageView.isHidden = false
        self.detailTitleLabel.text = StringConstants.s13LbExchangeDetail.localized
    }
    
    private func setupTransfer() {
        self.detailView.isHidden = false
        self.equivalentView.isHidden = true
        self.lineView.isHidden = true
        self.merchantView.isHidden = true
        self.couponView.isHidden = true
        self.detailTitleLabel.text = StringConstants.s05LbTransferFrom.localized
    }
    
    private func setupRemittance() {
        self.detailView.isHidden = false
        self.equivalentView.isHidden = true
        self.lineView.isHidden = true
        self.merchantView.isHidden = true
        self.couponView.isHidden = true
        self.detailTitleLabel.text = StringConstants.s10LbPurchased.localized
    }
    
    private func setupUseCoupon() {
        self.detailView.isHidden = true
    }
    
}
