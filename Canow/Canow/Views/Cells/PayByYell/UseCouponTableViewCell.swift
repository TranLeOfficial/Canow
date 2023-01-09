//
//  UseCouponTableViewCell.swift
//  Canow
//
//  Created by NhanTT13 on 12/23/21.
//

import UIKit
import Kingfisher

class UseCouponTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var topView: UIView! {
        didSet {
            self.topView.clipsToBounds = true
            self.topView.layer.cornerRadius = 8
            self.topView.backgroundColor = .color000000Alpha10
        }
    }
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            self.bottomView.clipsToBounds = true
            self.bottomView.layer.cornerRadius = 8
            self.bottomView.backgroundColor = .color000000Alpha10
        }
    }
    @IBOutlet weak var someView: UIView! {
        didSet {
            self.someView.clipsToBounds = true
            self.someView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var merchantNameLabel: UILabel! {
        didSet {
            self.merchantNameLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet weak var expiryDateLabel: UILabel! {
        didSet {
            self.expiryDateLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var ticketImageView: UIImageView! {
        didSet {
            self.ticketImageView.layer.cornerRadius = 6
            self.ticketImageView.layer.borderWidth = 1
            self.ticketImageView.layer.borderColor = UIColor.colorE5E5E5.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func configure<T>(data: T) {
        if let coupon = data as? CouponMerchantInfo {
            if let couponImageUrl = CommonManager.getImageURL(coupon.image) {
                self.ticketImageView.kf.setImage(with: couponImageUrl)
            }
            self.couponNameLabel.text = coupon.couponName
            self.merchantNameLabel.text = coupon.merchantName
            self.expiryDateLabel.text = "\(StringConstants.s14ExpiryDate.localized) \(coupon.expiredDate.formatDateString())"
        }
    }
}
