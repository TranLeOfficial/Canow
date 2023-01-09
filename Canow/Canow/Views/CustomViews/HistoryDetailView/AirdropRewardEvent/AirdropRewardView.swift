//
//  AirdropRewardView.swift
//  Canow
//
//  Created by NhanTT13 on 3/4/22.
//

import UIKit

class AirdropRewardView: UIView {
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var successfulLabel: UILabel! {
        didSet {
            self.successfulLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet weak var logoSTImage: UIImageView! {
        didSet {
            self.logoSTImage.rounded()
        }
    }
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.font = .font(with: .medium500, size: 14)
            self.dateLabel.textColor = .color646464
        }
    }
    @IBOutlet weak var rewardFromLabel: UILabel! {
        didSet {
            self.rewardFromLabel.font = .font(with: .medium500, size: 12)
            self.rewardFromLabel.textColor = .colorBlack111111
            self.rewardFromLabel.text = "\(StringConstants.s07LbRewardFrom.localized)"
        }
    }
    @IBOutlet weak var eventNameLabel: UILabel! {
        didSet {
            self.eventNameLabel.font = .font(with: .bold700, size: 14)
            self.eventNameLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var idLabel: UILabel! {
        didSet {
            self.idLabel.font = .font(with: .medium500, size: 12)
            self.idLabel.textColor = .color646464
            self.idLabel.text = "\(StringConstants.s07LbId.localized):"
        }
    }
    @IBOutlet weak var transactionIdLabel: UILabel! {
        didSet {
            self.transactionIdLabel.font = .font(with: .bold700, size: 12)
            self.transactionIdLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            self.messageLabel.font = .font(with: .medium500, size: 12)
            self.messageLabel.textColor = .colorBlack111111
            self.messageLabel.text = "\(StringConstants.reason.localized)"
        }
    }
    @IBOutlet weak var contentMessageLabel: UILabel! {
        didSet {
            self.contentMessageLabel.font = .font(with: .medium500, size: 14)
            self.contentMessageLabel.textColor = .color646464
        }
    }
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var transactionImageView: UIImageView!
    
    // MARK: - Properties
    var imageST: String = "" {
        didSet {
            self.logoSTImage.kf.setImage(with: CommonManager.getImageURL(self.imageST))
        }
    }
    
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = "\(self.amount)".formatPrice()
        }
    }
    
    var transactionDate: String = "" {
        didSet {
            self.dateLabel.text = transactionDate.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
        }
    }
    
    var rewardTitle: String = "" {
        didSet {
            self.rewardFromLabel.text = "\(self.rewardTitle):"
        }
    }
    
    var eventName: String = "" {
        didSet {
            self.eventNameLabel.text = self.eventName
        }
    }
    
    var messageReason = "" {
        didSet {
            self.contentMessageLabel.text = self.messageReason
        }
    }
    
    var transactionId: String = "" {
        didSet {
            self.transactionIdLabel.text = self.transactionId.transactionIdFormat()
        }
    }
    
    var transactionStatus: TransactionStatus = .pending {
        didSet {
            self.successfulLabel.text = self.transactionStatus.message
            switch self.transactionStatus {
            case .pending:
                self.transactionImageView.image = UIImage(named: "bg_processing_transaction")
                self.successfulLabel.textColor = .color646464
            case .completed:
                self.transactionImageView.image = UIImage(named: "bg_success_transaction")
                self.successfulLabel.textColor = .colorGreen339A06
            case .failed:
                self.transactionImageView.image = UIImage(named: "bg_failed_transaction")
                self.successfulLabel.textColor = .colorRedEB2727
            }
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
extension AirdropRewardView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AirdropRewardView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
