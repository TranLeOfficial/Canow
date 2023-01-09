//
//  AirdropUseCouponView.swift
//  Canow
//
//  Created by NhanTT13 on 3/7/22.
//

import UIKit

class AirdropUseCouponView: UIView {
    
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var transactionStatusImage: UIImageView!
    @IBOutlet weak var transactionStatusLabel: UILabel! {
        didSet {
            self.transactionStatusLabel.font = .font(with: .bold700, size: 14)
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
    @IBOutlet weak var useCouponLabel: UILabel! {
        didSet {
            self.useCouponLabel.font = .font(with: .medium500, size: 12)
            self.useCouponLabel.textColor = .colorBlack111111
            self.useCouponLabel.text = StringConstants.s07LbUsedCouon.localized
        }
    }
    @IBOutlet weak var couponImage: UIImageView! {
        didSet {
            self.couponImage.layer.cornerRadius = 5
            self.couponImage.layer.borderWidth = 0.2
            self.couponImage.layer.borderColor = UIColor.color646464.cgColor
        }
    }
    @IBOutlet weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.font = .font(with: .medium500, size: 12)
            self.merchantNameLabel.textColor = .color646464
        }
    }
    @IBOutlet weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.font = .font(with: .bold700, size: 14)
            self.couponNameLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var itemNameLabel: UILabel! {
        didSet {
            self.itemNameLabel.font = .font(with: .medium500, size: 12)
            self.itemNameLabel.textColor = .color646464
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
    @IBOutlet weak var teamLabel: UILabel! {
        didSet {
            self.teamLabel.font = .font(with: .medium500, size: 12)
            self.teamLabel.textColor = .colorBlack111111
            self.teamLabel.text = StringConstants.team.localized
        }
    }
    @IBOutlet weak var teamImage: UIImageView! {
        didSet {
            self.teamImage.rounded()
        }
    }
    @IBOutlet weak var teamNameLabel: UILabel! {
        didSet {
            self.teamNameLabel.font = .font(with: .bold700, size: 14)
            self.teamNameLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var eventNameLabel: UILabel! {
        didSet {
            self.eventNameLabel.font = .font(with: .medium500, size: 12)
            self.eventNameLabel.textColor = .color646464
        }
    }
    
    // MARK: - Properties
    var imageTransaction: String = "" {
        didSet {
            self.transactionStatusImage.image = UIImage(named: imageTransaction)
        }
    }
    
    var titleTransaction: String = "" {
        didSet {
            self.transactionStatusLabel.text = self.titleTransaction
        }
    }
    
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
    
    var imageCoupon: String = "" {
        didSet {
            self.couponImage.kf.setImage(with: CommonManager.getImageURL(self.imageCoupon))
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
    
    var transactionId: String = "" {
        didSet {
            self.transactionIdLabel.text = self.transactionId.transactionIdFormat()
        }
    }
    
    var reason: String = "" {
        didSet {
            self.contentMessageLabel.text = self.reason
        }
    }
    
    var imageTeam: String = "" {
        didSet {
            self.teamImage.kf.setImage(with: CommonManager.getImageURL(self.imageTeam))
        }
    }
    
    var teamName: String = "" {
        didSet {
            self.teamNameLabel.text = self.teamName
        }
    }
    
    var eventName: String = "" {
        didSet {
            self.eventNameLabel.text = self.eventName
        }
    }
    var transactionStatus: TransactionStatus = .pending {
        didSet {
            self.transactionStatusLabel.text = self.transactionStatus.message
            switch self.transactionStatus {
            case .pending:
                self.transactionStatusImage.image = UIImage(named: "bg_processing_transaction")
                self.transactionStatusLabel.textColor = .color646464
            case .completed:
                self.transactionStatusImage.image = UIImage(named: "bg_success_transaction")
                self.transactionStatusLabel.textColor = .colorGreen339A06
            case .failed:
                self.transactionStatusImage.image = UIImage(named: "bg_failed_transaction")
                self.transactionStatusLabel.textColor = .colorRedEB2727
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
extension AirdropUseCouponView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AirdropUseCouponView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
