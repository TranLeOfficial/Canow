//
//  PayWithoutCouponView.swift
//  Canow
//
//  Created by TuanBM6 on 1/22/22.
//

import UIKit
import Kingfisher

class PayWithoutCouponView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
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
    
    @IBOutlet private weak var idTitleLabel: UILabel! {
        didSet {
            self.idTitleLabel.font = .font(with: .medium500, size: 12)
            self.idTitleLabel.textColor = .color646464
            self.idTitleLabel.text = StringConstants.s07LbId.localized
        }
    }
    
    @IBOutlet private weak var merchantLogoImageView: UIImageView! {
        didSet {
            self.merchantLogoImageView.layer.cornerRadius = self.merchantLogoImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.font = .font(with: .bold700, size: 14)
            self.merchantNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var merchantTitleLabel: UILabel! {
        didSet {
            self.merchantTitleLabel.font = .font(with: .medium500, size: 12)
            self.merchantTitleLabel.textColor = .colorBlack111111
            self.merchantTitleLabel.text = StringConstants.s06Merchant.localized
        }
    }
    
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var transactionImageView: UIImageView!
    @IBOutlet private weak var stableTokenImageView: UIImageView!
    
    // MARK: - Properties
    var merchantName: String = "" {
        didSet {
            self.merchantNameLabel.text = self.merchantName
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
extension PayWithoutCouponView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PayWithoutCouponView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }

}
