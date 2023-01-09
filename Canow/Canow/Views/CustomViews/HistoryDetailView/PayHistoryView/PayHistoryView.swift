//
//  PayHistoryView.swift
//  Canow
//
//  Created by TuanBM6 on 1/22/22.
//

import UIKit
import Kingfisher

class PayHistoryView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet private weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.font = .font(with: .bold700, size: 14)
            self.couponNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.font = .font(with: .bold700, size: 14)
            self.merchantNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var campaginNameLabel: UILabel! {
        didSet {
            self.campaginNameLabel.font = .font(with: .medium500, size: 12)
            self.campaginNameLabel.textColor = .color5D5D5D
        }
    }
    
    @IBOutlet private weak var merchantNameCouponLabel: UILabel! {
        didSet {
            self.merchantNameCouponLabel.font = .font(with: .medium500, size: 12)
            self.merchantNameCouponLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var itemNameLabel: UILabel! {
        didSet {
            self.itemNameLabel.font = .font(with: .medium500, size: 12)
            self.itemNameLabel.textColor = .color5D5D5D
        }
    }
    
    @IBOutlet private weak var merchantLogoImageView: UIImageView! {
        didSet {
            self.merchantLogoImageView.layer.cornerRadius = self.merchantLogoImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var couponImageView: UIImageView! {
        didSet {
            self.couponImageView.layer.cornerRadius = 6
            self.couponImageView.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.couponImageView.layer.borderWidth = 1
        }
    }
    
    @IBOutlet private weak var transactionIdLabel: UILabel! {
        didSet {
            self.transactionIdLabel.font = .font(with: .bold700, size: 12)
            self.transactionIdLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var transactionStatusLabel: UILabel! {
        didSet {
            self.transactionStatusLabel.font = .font(with: .bold700, size: 14)
            self.transactionStatusLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var transactiondateLabel: UILabel! {
        didSet {
            self.transactiondateLabel.font = .font(with: .medium500, size: 14)
            self.transactiondateLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var useCouponTitleLabel: UILabel! {
        didSet {
            self.useCouponTitleLabel.font = .font(with: .medium500, size: 12)
            self.useCouponTitleLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var idTitleLabel: UILabel! {
        didSet {
            self.idTitleLabel.font = .font(with: .medium500, size: 12)
            self.idTitleLabel.textColor = .color646464
            self.idTitleLabel.text = StringConstants.s07LbId.localized
        }
    }
    
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var merchantTitleLabel: UILabel! {
        didSet {
            self.merchantTitleLabel.font = .font(with: .medium500, size: 12)
            self.merchantTitleLabel.textColor = .colorBlack111111
            self.merchantTitleLabel.text = StringConstants.s06Merchant.localized
        }
    }
    
    @IBOutlet private weak var stableTokenImageView: UIImageView!
    @IBOutlet private weak var transactionImageView: UIImageView!
    
    // MARK: - Properties
    var couponName: String = "" {
        didSet {
            self.couponNameLabel.text = self.couponName
        }
    }
    
    var merchantName: String = "" {
        didSet {
            self.merchantNameLabel.text = self.merchantName
        }
    }
    var merchantNameCoupon: String = "" {
        didSet {
            self.merchantNameCouponLabel.text = self.merchantNameCoupon
        }
    }
    var teamName: String = "" {
        didSet {
            self.merchantNameLabel.text = self.teamName
        }
    }
    
    var itemName: String = "" {
        didSet {
            self.itemNameLabel.text = self.itemName
        }
    }
    
    var couponLogo: String = "" {
        didSet {
            self.couponImageView.kf.setImage(with: CommonManager.getImageURL(self.couponLogo))
        }
    }
    
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = "\(self.amount)".formatPrice()
        }
    }
    
    var transactionId: String = "" {
        didSet {
            self.transactionIdLabel.text = self.transactionId.transactionIdFormat()
        }
    }
    
    var merchantLogo: String = "" {
        didSet {
            self.merchantLogoImageView.kf.setImage(with: CommonManager.getImageURL(self.merchantLogo))
        }
    }
    
    var merchantNameTitle: String = "" {
        didSet {
            self.merchantNameCouponLabel.text = merchantNameTitle
        }
    }
    
    var transactionStatus: TransactionStatus = .pending {
        didSet {
            self.transactionStatusLabel.text = self.transactionStatus.message
            switch self.transactionStatus {
            case .pending:
                self.transactionImageView.image = UIImage(named: "bg_processing_transaction")
                self.transactionStatusLabel.textColor = .color646464
            case .completed:
                self.transactionImageView.image = UIImage(named: "bg_success_transaction")
                self.transactionStatusLabel.textColor = .colorGreen339A06
            case .failed:
                self.transactionImageView.image = UIImage(named: "bg_failed_transaction")
                self.transactionStatusLabel.textColor = .colorRedEB2727
            }
        }
    }
    
    var transactionDate: String = "" {
        didSet {
            self.transactiondateLabel.text = transactionDate.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
        }
    }
    
    var stableTokenLogo: String = "" {
        didSet {
            self.stableTokenImageView.kf.setImage(with: CommonManager.getImageURL(self.stableTokenLogo))
        }
    }
    
    var isHiddenCampaginName: Bool = true {
        didSet {
            self.campaginNameLabel.isHidden = self.isHiddenCampaginName
        }
    }
    
    var campaginName: String = "" {
        didSet {
            self.campaginNameLabel.isHidden = false
            self.campaginNameLabel.text = self.campaginName
        }
    }
    
    var merchantTitle: String = "" {
        didSet {
            self.merchantTitleLabel.text = self.merchantTitle
        }
    }
    var transactionTitle: String = "" {
        didSet {
            self.useCouponTitleLabel.text = self.transactionTitle
        }
    }
    var teamTitle: String = "" {
        didSet {
            self.merchantTitleLabel.text = self.teamTitle
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

// MARK: - Extension
extension PayHistoryView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PayHistoryView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }

}
