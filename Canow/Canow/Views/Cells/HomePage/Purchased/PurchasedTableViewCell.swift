//
//  PurchasedTableViewCell.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import UIKit
import Kingfisher

class PurchasedTableViewCell: BaseTableViewCell {
    
    // MARK: - Outlets
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var itemPurchasedView: ItemPurchased! {
        didSet {
            self.itemPurchasedView.dropShadow()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure<T>(data: T) {
        if let purchased = data as? PurchasedInfo {
            self.itemPurchasedView.itemImageView.kf.setImage(with: CommonManager.getImageURL(purchased.image))
            self.itemPurchasedView.merchantName = purchased.merchantName
            self.itemPurchasedView.couponName = purchased.couponName
            self.itemPurchasedView.usableDate = convertDateToString(stringDate: purchased.usableFrom)
            self.itemPurchasedView.expireDate = convertDateToString(stringDate: purchased.expiredDate)
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
