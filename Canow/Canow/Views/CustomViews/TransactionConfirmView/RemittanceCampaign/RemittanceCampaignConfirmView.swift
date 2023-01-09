//
//  RemittanceCampaignConfirmView.swift
//  Canow
//
//  Created by NhanTT13 on 1/15/22.
//

import UIKit

class RemittanceCampaignConfirmView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var imageStatusView: UIImageView! {
        didSet {
            self.imageStatusView.image = UIImage(named: "bg_confirm_transaction")
        }
    }
    @IBOutlet weak var transactionStatusLabel: UILabel! {
        didSet {
            self.transactionStatusLabel.text = StringConstants.s05TransactionConfirm.localized
            self.transactionStatusLabel.font = .font(with: .bold700, size: 14)
            self.transactionStatusLabel.textColor = .color646464
        }
    }
    @IBOutlet weak var fantokenImage: UIImageView! {
        didSet {
            self.fantokenImage.rounded()
        }
    }
    @IBOutlet weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.font = .font(with: .bold700, size: 30)
        }
    }
    @IBOutlet weak var titlePurchasedLabel: UILabel! {
        didSet {
            self.titlePurchasedLabel.textColor = .colorBlack111111
            self.titlePurchasedLabel.text = StringConstants.s10LbPurchased.localized
            self.titlePurchasedLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var itemImage: UIImageView! {
        didSet {
            self.itemImage.rounded()
        }
    }
    @IBOutlet weak var nameItemLabel: UILabel! {
        didSet {
            self.nameItemLabel.textColor = .colorBlack111111
            self.nameItemLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet weak var capaignNameLabel: UILabel! {
        didSet {
            self.capaignNameLabel.textColor = .color646464
            self.capaignNameLabel.font = .font(with: .medium500, size: 12)
        }
    }
    
    // MARK: - Properties
    var imageFantoken: String = "" {
        didSet {
            self.fantokenImage.kf.setImage(with: CommonManager.getImageURL(imageFantoken))
        }
    }
    var balanceCampaign: String = "" {
        didSet {
            self.balanceLabel.text = balanceCampaign.formatPrice()
        }
    }
    var avatarImageItem: String = "" {
        didSet {
            self.itemImage.kf.setImage(with: CommonManager.getImageURL(avatarImageItem))
        }
    }
    var nameItem: String = "" {
        didSet {
            self.nameItemLabel.text = nameItem
        }
    }
    var nameCampaign: String = "" {
        didSet {
            self.capaignNameLabel.text = nameCampaign
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

extension RemittanceCampaignConfirmView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("RemittanceCampaignConfirmView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
