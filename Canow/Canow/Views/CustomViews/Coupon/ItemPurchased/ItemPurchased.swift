//
//  ItemPurchased.swift
//  Canow
//
//  Created by Nguyen Thanh Phuc on 1/17/22.
//

import UIKit

class ItemPurchased: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            self.itemImageView.configBorder(borderWidth: 1,
                                            borderColor: .colorE5E5E5,
                                            cornerRadius: 6)
        }
    }
    @IBOutlet private weak var merchantLabel: UILabel! {
        didSet {
            self.merchantLabel.textColor = .color646464
            self.merchantLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.textColor = .colorBlack111111
            self.couponNameLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet private weak var usableTitleLabel: UILabel! {
        didSet {
            self.usableTitleLabel.text = StringConstants.s14UsableFrom.localized
            self.usableTitleLabel.textColor = .color646464
            self.usableTitleLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var expireTitleLabel: UILabel! {
        didSet {
            self.expireTitleLabel.text = StringConstants.s14ExpiryDate.localized
            self.expireTitleLabel.textColor = .color646464
            self.expireTitleLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var usableLabel: UILabel! {
        didSet {
            self.usableLabel.textColor = .color646464
            self.usableLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var expireLabel: UILabel! {
        didSet {
            self.expireLabel.textColor = .color646464
            self.expireLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var usableFromView: UIView!
    
    @IBOutlet weak var avatarView: UIView! {
        didSet {
            self.avatarView.layer.cornerRadius = 6
            self.avatarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet private weak var infomationView: UIView! {
        didSet {
            self.infomationView.layer.cornerRadius = 6
            self.infomationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    // MARK: - Properties
    var itemUrl: String? {
        didSet {
            self.itemImageView.kf.setImage(with: CommonManager.getImageURL(self.itemUrl))
        }
    }
    var merchantName: String? {
        didSet {
            self.merchantLabel.text = self.merchantName
        }
    }
    var couponName: String? {
        didSet {
            self.couponNameLabel.text = self.couponName
        }
    }
    var usableDate: String? {
        didSet {
            self.usableLabel.text = self.usableDate
            self.usableFromView.isHidden = self.usableDate == ""
        }
    }
    var expireDate: String? {
        didSet {
            self.expireLabel.text = self.expireDate
        }
    }
    var cornerRadius: CGFloat = 6 {
        didSet {
            self.avatarView.layer.cornerRadius = self.cornerRadius
            self.infomationView.layer.cornerRadius = self.cornerRadius
        }
    }
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
}

// MARK: - Methods
extension ItemPurchased {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ItemPurchased", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
