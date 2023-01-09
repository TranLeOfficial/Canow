//
//  CouponAvailableCell.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import UIKit
import Kingfisher

class CouponAvailableCell: BaseTableViewCell {

    @IBOutlet private weak var merchantNameLabel: UILabel!
    @IBOutlet private weak var couponNameLabel: UILabel!
    @IBOutlet private weak var createLabel: UILabel! {
        didSet {
            self.createLabel.text = StringConstants.availableDate.localized
        }
    }
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var expiredDateLabel: UILabel!
    @IBOutlet weak var expiredLabel: UILabel! {
        didSet {
            self.expiredLabel.text = StringConstants.purchasedDate.localized
        }
    }
    @IBOutlet weak var CouponImageView: UIImageView!
    @IBOutlet weak var fantokenTickerLabel: UILabel! {
        didSet {
            self.fantokenTickerLabel.textColor = .red
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func configure<T>(data: T) {
        guard let data = data as? CouponInfo else {
            return
        }
        self.merchantNameLabel.text = data.merchantName
        self.createdAtLabel.text = data.availableTo.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? ""
        self.expiredDateLabel.text = data.expiredDate.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? ""
        self.couponNameLabel.text = data.couponName
        self.fantokenTickerLabel.text = "\(data.price) \(data.fantokenTicker)"
        guard let url = CommonManager.getImageURL(data.image) else {
            return
        }
        self.CouponImageView.kf.setImage(with: url)
    }
}
