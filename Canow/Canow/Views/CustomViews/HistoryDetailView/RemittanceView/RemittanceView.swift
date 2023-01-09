//
//  RemittanceView.swift
//  Canow
//
//  Created by TuanBM6 on 1/22/22.
//

import UIKit

class RemittanceView: UIView {

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
    
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var purchasedLogoImageView: UIImageView! {
        didSet {
            self.purchasedLogoImageView.layer.cornerRadius = self.purchasedLogoImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var purchasedNameLabel: UILabel! {
        didSet {
            self.purchasedNameLabel.font = .font(with: .bold700, size: 14)
            self.purchasedNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var purchasedTitleLabel: UILabel! {
        didSet {
            self.purchasedTitleLabel.font = .font(with: .medium500, size: 12)
            self.purchasedTitleLabel.textColor = .colorBlack111111
            self.purchasedTitleLabel.text = StringConstants.s10LbPurchased.localized
        }
    }
    
    @IBOutlet private weak var teamTitleLabel: UILabel! {
        didSet {
            self.teamTitleLabel.font = .font(with: .medium500, size: 12)
            self.teamTitleLabel.textColor = .colorBlack111111
            self.teamTitleLabel.text = StringConstants.s07TitleTeam.localized
        }
    }
    
    @IBOutlet private weak var teamNameLabel: UILabel! {
        didSet {
            self.teamNameLabel.font = .font(with: .bold700, size: 14)
            self.teamNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var campaignNameLabel: UILabel! {
        didSet {
            self.campaignNameLabel.font = .font(with: .medium500, size: 12)
            self.campaignNameLabel.textColor = .color5D5D5D
        }
    }
    
    @IBOutlet private weak var teamLogoImageView: UIImageView! {
        didSet {
            self.teamLogoImageView.layer.cornerRadius = self.teamLogoImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var transactionImageView: UIImageView!
    @IBOutlet private weak var stableTokenImageView: UIImageView!
    
    // MARK: - Properties
    var purchasedName: String = "" {
        didSet {
            self.purchasedNameLabel.text = self.purchasedName
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
    
    var purchasedLogo: String = "" {
        didSet {
            self.purchasedLogoImageView.kf.setImage(with: CommonManager.getImageURL(self.purchasedLogo))
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
    
    var teamLogo: String = "" {
        didSet {
            self.teamLogoImageView.kf.setImage(with: CommonManager.getImageURL(teamLogo))
        }
    }
    
    var teamName: String = "" {
        didSet {
            self.teamNameLabel.text = self.teamName
        }
    }
    
    var campaignName: String = "" {
        didSet {
            self.campaignNameLabel.text = self.campaignName
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
extension RemittanceView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RemittanceView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }

}
