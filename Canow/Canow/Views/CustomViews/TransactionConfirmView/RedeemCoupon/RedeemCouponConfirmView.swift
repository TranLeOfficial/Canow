//
//  RedeemCouponConfirmView.swift
//  Canow
//
//  Created by NhiVHY on 1/11/22.
//

import UIKit

class RedeemCouponConfirmView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var transactionConfirmLabel: UILabel! {
        didSet {
            self.transactionConfirmLabel.font = .font(with: .bold700, size: 14)
            self.transactionConfirmLabel.textColor = .color646464
            self.transactionConfirmLabel.text = StringConstants.s05TransactionConfirm.localized
        }
    }
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var balanceImageView: UIImageView!
    @IBOutlet private weak var redeemedLabel: UILabel! {
        didSet {
            self.redeemedLabel.text = StringConstants.s14RedeemedCoupon.localized
            self.redeemedLabel.font = .font(with: .medium500, size: 12)
            self.redeemedLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var couponImageView: UIImageView! {
        didSet {
            self.couponImageView.layer.cornerRadius = 6
            self.couponImageView.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.couponImageView.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var merchantNameLabel: UILabel!
    @IBOutlet private weak var couponNameLabel: UILabel!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var usableFromLabel: UILabel!
    
    // MARK: - Properties
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = String(self.amount).formatPrice()
        }
    }
    var balanceImageURL: String = "" {
        didSet {
            self.balanceImageView.kf.setImage(with: CommonManager.getImageURL(self.balanceImageURL))
        }
    }
    var couponImageURL: String = "" {
        didSet {
            self.couponImageView.kf.setImage(with: CommonManager.getImageURL(self.couponImageURL))
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
    
    var usableFrom: String = "" {
        didSet {
            self.usableFromLabel.text = self.usableFrom
            self.usableFromLabel.isHidden = false
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

extension RedeemCouponConfirmView {
    private func commonInit() {
        Bundle.main.loadNibNamed("RedeemCouponConfirmView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
}
