//
//  TopUpHistoryView.swift
//  Canow
//
//  Created by TuanBM6 on 1/21/22.
//

import UIKit
import Kingfisher

class TopUpHistoryView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet private weak var topUpNameLabel: UILabel! {
        didSet {
            self.topUpNameLabel.font = .font(with: .bold700, size: 14)
            self.topUpNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var topUpPhoneLabel: UILabel! {
        didSet {
            self.topUpPhoneLabel.font = .font(with: .medium500, size: 12)
            self.topUpPhoneLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var topUpAvatarImageView: UIImageView! {
        didSet {
            self.topUpAvatarImageView.layer.cornerRadius = self.topUpAvatarImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var topUpIconImageView: UIImageView! {
        didSet {
            self.topUpIconImageView.layer.cornerRadius = self.topUpIconImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var equivalentToLabel: UILabel! {
        didSet {
            self.equivalentToLabel.font = .font(with: .bold700, size: 12)
            self.equivalentToLabel.textColor = .colorBlack111111
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
    
    @IBOutlet private weak var transactionGiftCodeLabel: UILabel! {
        didSet {
            self.transactionGiftCodeLabel.font = .font(with: .medium500, size: 12)
            self.transactionGiftCodeLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var transactiondateLabel: UILabel! {
        didSet {
            self.transactiondateLabel.font = .font(with: .medium500, size: 14)
            self.transactiondateLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var giftCodeTitleLabel: UILabel! {
        didSet {
            self.giftCodeTitleLabel.font = .font(with: .bold700, size: 14)
            self.giftCodeTitleLabel.textColor = .colorBlack111111
            self.giftCodeTitleLabel.text = StringConstants.s07GiftCode.localized
        }
    }
    
    @IBOutlet private weak var topUpDetailTitleLabel: UILabel! {
        didSet {
            self.topUpDetailTitleLabel.font = .font(with: .medium500, size: 12)
            self.topUpDetailTitleLabel.textColor = .colorBlack111111
            self.topUpDetailTitleLabel.text = StringConstants.s04LbTopupDetail.localized
        }
    }
    
    @IBOutlet private weak var paymentTitleLabel: UILabel! {
        didSet {
            self.paymentTitleLabel.font = .font(with: .medium500, size: 12)
            self.paymentTitleLabel.textColor = .colorBlack111111
            self.paymentTitleLabel.text = StringConstants.s07PaymentMethod.localized
        }
    }
    
    @IBOutlet private weak var equivalentToTitleLabel: UILabel! {
        didSet {
            self.equivalentToTitleLabel.font = .font(with: .medium500, size: 12)
            self.equivalentToTitleLabel.textColor = .color646464
            self.equivalentToTitleLabel.text = StringConstants.s04EquivalentTo.localized
        }
    }
    
    @IBOutlet private weak var idTitleLabel: UILabel! {
        didSet {
            self.idTitleLabel.font = .font(with: .medium500, size: 12)
            self.idTitleLabel.textColor = .color646464
            self.idTitleLabel.text = StringConstants.s07LbId.localized
        }
    }
    
    @IBOutlet private weak var transactionImageView: UIImageView!
    @IBOutlet private weak var tokenLogoImageView: UIImageView!
        
    // MARK: - Properties
    var customerAvatar: String = "" {
        didSet {
            self.topUpAvatarImageView.kf.setImage(with: CommonManager.getImageURL(self.customerAvatar))
        }
    }
    
    var transactionImage: String = "" {
        didSet {
            self.transactionImageView.kf.setImage(with: CommonManager.getImageURL(self.transactionImage))
        }
    }
    
    var customerName: String = "" {
        didSet {
            self.topUpNameLabel.text = self.customerName
        }
    }
    
    var customerPhone: String = "" {
        didSet {
            self.topUpPhoneLabel.text = self.customerPhone
        }
    }
    
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = "\(self.amount)".formatPrice()
            self.equivalentToLabel.text = "\(self.amount)".formatPrice() + "¥"
        }
    }
    
    var transactionId: String = "" {
        didSet {
            self.transactionIdLabel.text = self.transactionId.transactionIdFormat()
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
    
    var giftCode: String = "" {
        didSet {
            if giftCode == "" {
                self.transactionGiftCodeLabel.isHidden = true
                self.giftCodeTitleLabel.text = StringConstants.s07CreditCard.localized
                self.topUpIconImageView.image = UIImage(named: "ic_TopupCreditCard")
            }
            self.transactionGiftCodeLabel.text = self.giftCode
        }
    }
    
    var tokenLogo: String = "" {
        didSet {
            self.tokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(self.tokenLogo))
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
extension TopUpHistoryView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TopUpHistoryView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }

}
