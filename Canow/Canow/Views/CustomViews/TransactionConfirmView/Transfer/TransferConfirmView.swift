//
//  TransferConfirmView.swift
//  Canow
//
//  Created by NhiVHY on 1/14/22.
//

import UIKit

class TransferConfirmView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet private weak var transactionConfirmLabel: UILabel! {
        didSet {
            self.transactionConfirmLabel.text = StringConstants.s05TransactionConfirm.localized
        }
    }
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var fromLabel: UILabel! {
        didSet {
            self.fromLabel.text = StringConstants.s05LbFrom.localized
        }
    }
    @IBOutlet private weak var toLabel: UILabel! {
        didSet {
            self.toLabel.text = StringConstants.s05LbTo.localized
        }
    }
    @IBOutlet private weak var fromAvatarImageView: UIImageView! {
        didSet {
            self.fromAvatarImageView.layer.cornerRadius = self.fromAvatarImageView.bounds.height/2
        }
    }
    @IBOutlet private weak var fromNameLabel: UILabel!
    @IBOutlet private weak var fromPhoneLabel: UILabel!
    @IBOutlet private weak var toAvatarImageView: UIImageView! {
        didSet {
            self.toAvatarImageView.layer.cornerRadius = self.toAvatarImageView.bounds.height/2
        }
    }
    @IBOutlet private weak var toNameLabel: UILabel!
    @IBOutlet private weak var toPhoneLabel: UILabel!
    @IBOutlet weak var logoTokenImageView: UIImageView!
    
    // MARK: - Properties
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = String(self.amount).formatPrice()
        }
    }
    var fromAvatarURL: String = "" {
        didSet {
            if fromAvatarURL == "" {
                self.fromAvatarImageView.image = UIImage(named: "ic_avatar")
            } else {
                self.fromAvatarImageView.kf.setImage(with: CommonManager.getImageURL(self.fromAvatarURL))
            }
        }
    }
    var fromName: String = "" {
        didSet {
            self.fromNameLabel.text = self.fromName
        }
    }
    var fromPhone: String = "" {
        didSet {
            self.fromPhoneLabel.text = self.fromPhone
        }
    }
    var toAvatarURL: String = "" {
        didSet {
            if toAvatarURL == "" {
                self.toAvatarImageView.image = UIImage(named: "ic_avatar")
            } else {
                self.toAvatarImageView.kf.setImage(with: CommonManager.getImageURL(self.toAvatarURL))
            }
        }
    }
    var toName: String = "" {
        didSet {
            self.toNameLabel.text = self.toName
        }
    }
    var toPhone: String = "" {
        didSet {
            self.toPhoneLabel.text = self.toPhone
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

extension TransferConfirmView {
    private func commonInit() {
        Bundle.main.loadNibNamed("TransferConfirmView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
}
