//
//  NotPurchasedTableViewCell.swift
//  Canow
//
//  Created by PhucNT34 on 1/15/22.
//

import UIKit
import Kingfisher

class NotPurchasedTableViewCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemReddemView: ItemRedeemView! {
        didSet {
            self.itemReddemView.dropShadow()
        }
    }
    
    // MARK: - Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure<T>(data: T) {
        if let notPurchased = data as? CouponInfo {
            self.itemReddemView.itemImageView.kf.setImage(with: CommonManager.getImageURL(notPurchased.image))
            self.itemReddemView.merchantName = notPurchased.merchantName
            self.itemReddemView.couponName = notPurchased.couponName
            self.itemReddemView.progressTotal = notPurchased.quantity
            let redeemedQuantity = Int(notPurchased.redeemedQuantity) ?? 0
            let remainingQuantity = notPurchased.quantity - (Int(notPurchased.redeemedQuantity) ?? 0)
            self.itemReddemView.progressCurrent = redeemedQuantity
            self.itemReddemView.progressRemaining = remainingQuantity
            self.itemReddemView.usableDate = convertDateToString(stringDate: notPurchased.availableTo)
            self.itemReddemView.expireDate = convertDateToString(stringDate: notPurchased.expiredDate)
        }
    }
    
    private func convertDateToString(stringDate: String?) -> String {
        if let date: Date = stringDate?.toDate(dateFormat: DateFormat.DATE_CURRENT) {
            let string: String = date.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
            return string
        }
        return ""
    }
    
}
