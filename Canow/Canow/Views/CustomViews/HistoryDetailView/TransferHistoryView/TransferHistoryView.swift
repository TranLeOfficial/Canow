//
//  TransferHistoryView.swift
//  Canow
//
//  Created by TuanBM6 on 1/22/22.
//

import UIKit

class TransferHistoryView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet private weak var transferNameLabel: UILabel! {
        didSet {
            self.transferNameLabel.font = .font(with: .bold700, size: 14)
            self.transferNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var transferPhoneLabel: UILabel! {
        didSet {
            self.transferPhoneLabel.font = .font(with: .medium500, size: 12)
            self.transferPhoneLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var transferAvatarImageView: UIImageView! {
        didSet {
            self.transferAvatarImageView.layer.cornerRadius = self.transferAvatarImageView.frame.height / 2
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
    
    @IBOutlet private weak var transactiondateLabel: UILabel! {
        didSet {
            self.transactiondateLabel.font = .font(with: .medium500, size: 14)
            self.transactiondateLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var transferTitleLabel: UILabel! {
        didSet {
            self.transferTitleLabel.font = .font(with: .medium500, size: 12)
            self.transferTitleLabel.textColor = .colorBlack111111
            self.transferTitleLabel.text = StringConstants.s05LbTransferFrom.localized
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
    @IBOutlet private weak var stableTokenImageView: UIImageView!
    @IBOutlet private weak var EquivalentStackView: UIStackView!
    
    // MARK: - Properties
    var customerAvatar: String = "" {
        didSet {
            if customerAvatar == "" {
                self.transferAvatarImageView.image = UIImage(named: "ic_avatar")
            } else {
                self.transferAvatarImageView.kf.setImage(with: CommonManager.getImageURL(self.customerAvatar))
            }
        }
    }
    
    var transactionImage: String = "" {
        didSet {
            self.transactionImageView.kf.setImage(with: CommonManager.getImageURL(self.transactionImage))
        }
    }
    
    var customerName: String = "" {
        didSet {
            self.transferNameLabel.text = self.customerName
        }
    }
    
    var customerPhone: String = "" {
        didSet {
            self.transferPhoneLabel.text = self.customerPhone
        }
    }
    
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = "\(self.amount)".formatPrice()
            self.equivalentToLabel.text = "\(self.amount)".formatPrice()
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
    
    var transferTitle: String = "" {
        didSet {
            self.transferTitleLabel.text = self.transferTitle
        }
    }
    
    var isHiddenEquivalent: Bool = true {
        didSet {
            self.EquivalentStackView.isHidden = isHiddenEquivalent
        }
    }
    
    var tokenLogo: String = "" {
        didSet {
            self.tokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(self.tokenLogo))
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
extension TransferHistoryView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TransferHistoryView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
