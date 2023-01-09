//
//  UseCouponConfirmView.swift
//  Canow
//
//  Created by NhiVHY on 1/14/22.
//

import UIKit

class UseCouponConfirmView: UIView {
    
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
    @IBOutlet private weak var usedCouponLabel: UILabel! {
        didSet {
            self.usedCouponLabel.text = StringConstants.s14UsedCoupon.localized
            self.usedCouponLabel.font = .font(with: .medium500, size: 14)
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
    @IBOutlet private weak var merchantTextLabel: UILabel! {
        didSet {
            self.merchantTextLabel.text = StringConstants.s06Merchant.localized
        }
    }
    @IBOutlet private weak var merchantImageView: UIImageView! {
        didSet {
            self.merchantImageView.rounded()
        }
    }
    @IBOutlet private weak var merchanNametBottomLabel: UILabel!
    @IBOutlet private weak var stableTokenImage: UIImageView! {
        didSet {
            self.stableTokenImage.rounded()
        }
    }
    @IBOutlet private weak var couponView: UIView!
    @IBOutlet private weak var merchantView: UIView!
    @IBOutlet private weak var lineView: UIView!
    
    // MARK: - Properties
    var imageST: String = "" {
        didSet {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(imageST))
        }
    }
    
    var amount: Int = 0 {
        didSet {
            self.amountLabel.text = "\(self.amount)".formatPrice()
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
            self.merchanNametBottomLabel.text = self.merchantName
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
    var merchantImageURL: String = "" {
        didSet {
            self.merchantImageView.kf.setImage(with: CommonManager.getImageURL(self.merchantImageURL))
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
extension UseCouponConfirmView {
    private func commonInit() {
        Bundle.main.loadNibNamed("UseCouponConfirmView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
}

// MARK: - Methods
extension UseCouponConfirmView {
    
    func setup(transactionType: TransactionType = .useCoupon, payType: PayType = .payDiscountCoupon) {
        switch transactionType {
        case .pay:
            switch payType {
            case .payDiscountCoupon:
                break
            case .payWithoutCoupon, .payPremoney:
                self.couponView.isHidden = true
                self.lineView.isHidden = true
            }
        default:
            break
        }
    }
}
