//
//  PurchasedCell.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import UIKit
import Kingfisher

class PurchasedCell: BaseTableViewCell {

    @IBOutlet private weak var merchantNameLabel: UILabel!
    @IBOutlet private weak var availableView: UIView!
    @IBOutlet private weak var merchantAvailableLabel: UILabel! {
        didSet {
            self.merchantAvailableLabel.text = StringConstants.availableDate.localized
        }
    }
    @IBOutlet private weak var availableLabel: UILabel!
    @IBOutlet private weak var couponNameLabel: UILabel!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var expiredDateLabel: UILabel!
    @IBOutlet private weak var expiredLabel: UILabel! {
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
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        self.cardView.dropShadow()
    }
    
    override func configure<T>(data: T) {
        guard let data = data as? PurchasedInfo else {
            return
        }
        if data.usableFrom != nil {
            self.availableView.isHidden = false
            self.availableLabel.text = data.availableFrom.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? ""
        } else {
            self.availableView.isHidden = true
        }
        self.merchantNameLabel.text = data.merchantName
        self.expiredDateLabel.text = data.expiredDate.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? ""
        self.couponNameLabel.text = data.couponName
        self.fantokenTickerLabel.text = "\(data.price) \(data.fantokenTicker)"
        guard let url = CommonManager.getImageURL(data.image) else {
            return
        }
        self.CouponImageView.kf.setImage(with: url)
    }
}
