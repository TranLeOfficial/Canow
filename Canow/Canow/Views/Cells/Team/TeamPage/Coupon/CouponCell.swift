//
//  CouponCell.swift
//  Canow
//
//  Created by hieplh2 on 03/12/2021.
//

import UIKit

class CouponCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var cardView: UIView! {
        didSet {
            self.cardView.clipsToBounds = true
            self.cardView.layer.cornerRadius = 6
        }
    }
    
    @IBOutlet private weak var couponImageView: UIImageView! {
        didSet {
            self.couponImageView.layer.cornerRadius = 6
            self.couponImageView.layer.borderWidth = 1
            self.couponImageView.layer.borderColor = UIColor.colorE5E5E5.cgColor
        }
    }
    
    @IBOutlet private weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.font = .font(with: .medium500, size: 12)
            self.merchantNameLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.font = .font(with: .bold700, size: 14)
            self.couponNameLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var availableDateLabel: UILabel! {
        didSet {
            self.availableDateLabel.font = .font(with: .medium500, size: 12)
            self.availableDateLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var expiredDateLabel: UILabel! {
        didSet {
            self.expiredDateLabel.font = .font(with: .medium500, size: 12)
            self.expiredDateLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var logoImageView: UIImageView! {
        didSet {
            self.logoImageView.layer.cornerRadius = self.logoImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var priceLabel: UILabel! {
        didSet {
            self.priceLabel.textColor = .colorBlack111111
            self.priceLabel.font = .font(with: .bold700, size: 16)
        }
    }
    
    @IBOutlet private weak var donateLabel: UILabel! {
        didSet {
            self.donateLabel.textColor = .color646464
            self.donateLabel.font = .font(with: .medium500, size: 14)
            self.donateLabel.text = StringConstants.s17LbDonate.localized
        }
    }
    
    @IBOutlet private weak var progressRedeemView: ProgressRedeemView!
    
    @IBOutlet private weak var donateRedeemButton: CustomButton! {
        didSet {
            self.donateRedeemButton.setTitle(StringConstants.s17BtnDonateRedeem.localized, for: .normal)
            self.donateRedeemButton.setTitle(StringConstants.s17BtnDonateRedeem.localized, for: .highlighted)
            self.donateRedeemButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.donateRedeemButton.setupUI()
        }
    }
    
    var donateRedeem: (String) -> Void = { _ in }
    private var couponId: String?
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.dropShadow()
    }
    
    @IBAction func donateRedeemAction(_ sender: Any) {
        guard let couponId = self.couponId else {
            return
        }
        self.donateRedeem(couponId)
    }
    
    override func configure<T>(data: T) {
        if let data = data as? CourseListDetail {
            self.couponImageView.kf.setImage(with: CommonManager.getImageURL(data.image))
            self.logoImageView.kf.setImage(with: CommonManager.getImageURL(data.fantokenLogo))
            
            self.merchantNameLabel.text = data.merchantName
            self.couponNameLabel.text = data.couponName
            
            self.availableDateLabel.text = "\(StringConstants.s17LbUsableFrom.localized) \(data.usableFrom.formatDateString())"
            self.expiredDateLabel.text = "\(StringConstants.s17LbExpiryDate.localized) \(data.expiredDate.formatDateString())"
            
            self.priceLabel.text = "\(data.price)".formatPrice()
            self.progressRedeemView.current = Int(data.redeemedQuantity) ?? 0
            self.progressRedeemView.remaining = Int(data.remainingQuantity) ?? 0
            self.progressRedeemView.total = data.quantity
            self.couponId = data.couponId
        }
    }
    
}
