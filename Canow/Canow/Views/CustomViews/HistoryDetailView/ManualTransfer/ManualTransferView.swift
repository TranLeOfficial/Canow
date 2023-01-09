//
//  ManualTransferView.swift
//  Canow
//
//  Created by NhanTT13 on 2/28/22.
//

import UIKit

class ManualTransferView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var successfullLabel: UILabel! {
        didSet {
            self.successfullLabel.font = .font(with: .bold700, size: 14)
            self.successfullLabel.text = StringConstants.s07LbSuccessful.localized
            self.successfullLabel.textColor = .color339A06
        }
    }
    @IBOutlet private weak var logoSTImage: UIImageView! {
        didSet {
            self.logoSTImage.rounded()
        }
    }
    @IBOutlet private weak var amountLabel: UILabel! {
        didSet {
            self.amountLabel.font = .font(with: .bold700, size: 30)
            self.amountLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.font = .font(with: .medium500, size: 14)
            self.dateLabel.textColor = .color646464
        }
    }
    @IBOutlet private weak var adminLabel: UILabel! {
        didSet {
            self.adminLabel.font = .font(with: .medium500, size: 12)
            self.adminLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var adminAvatarImage: UIImageView! {
        didSet {
            self.adminAvatarImage.rounded()
        }
    }
    @IBOutlet private weak var adminNameLabel: UILabel! {
        didSet {
            self.adminNameLabel.font = .font(with: .bold700, size: 14)
            self.adminNameLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var transactionIdLabel: UILabel! {
        didSet {
            self.transactionIdLabel.font = .font(with: .medium500, size: 12)
            self.transactionIdLabel.textColor = .color646464
            self.transactionIdLabel.text = "\(StringConstants.s07LbId.localized):"
        }
    }
    @IBOutlet private weak var transactionIdBoldLabel: UILabel! {
        didSet {
            self.transactionIdBoldLabel.font = .font(with: .bold700, size: 12)
            self.transactionIdBoldLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var messageLabel: UILabel! {
        didSet {
            self.messageLabel.font = .font(with: .medium500, size: 12)
            self.messageLabel.textColor = .colorBlack111111
            self.messageLabel.text = "\(StringConstants.reason.localized)"
        }
    }
    @IBOutlet private weak var contentMessageLabel: UILabel! {
        didSet {
            self.contentMessageLabel.font = .font(with: .medium500, size: 14)
            self.contentMessageLabel.textColor = .color646464
        }
    }
    
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
    
    var adminTitle: String = "" {
        didSet {
            self.adminLabel.text = "\(self.adminTitle)"
        }
    }
    
    var adminAvatar: String = "" {
        didSet {
            self.adminAvatarImage.kf.setImage(with: CommonManager.getImageURL(self.adminAvatar))
        }
    }
    
    var adminName: String = "" {
        didSet {
            self.adminNameLabel.text = self.adminName
        }
    }
    
    var messageReason = "" {
        didSet {
            self.contentMessageLabel.text = self.messageReason
        }
    }
    
    var transactionId: String = "" {
        didSet {
            self.transactionIdBoldLabel.text = self.transactionId.transactionIdFormat()
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
extension ManualTransferView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ManualTransferView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }

}
