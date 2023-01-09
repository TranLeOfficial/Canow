//
//  ItemView.swift
//  Canow
//
//  Created by hieplh2 on 04/01/2022.
//

import UIKit

class ItemView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            self.itemImageView.configBorder(borderWidth: 1,
                                            borderColor: .colorE5E5E5,
                                            cornerRadius: 6)
        }
    }
    @IBOutlet weak var merchantLabel: UILabel! {
        didSet {
            self.merchantLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var couponNameLabel: UILabel! {
        didSet {
            self.couponNameLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet weak var expireLabel: UILabel! {
        didSet {
            self.expireLabel.font = .font(with: .medium500, size: 12)
        }
    }
    
    @IBOutlet weak var expiryDateLabel: UILabel! {
        didSet {
            self.expiryDateLabel.text = StringConstants.s14ExpiryDate.localized
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
    var expireDate: String? {
        didSet {
            self.expireLabel.text = self.expireDate
            if expireDate?.toDate(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? Date() < Date() {
                self.expiryDateLabel.text = StringConstants.s15OutOfDate.localized
                self.expiryDateLabel.textColor = .colorRedEB2727
                self.expireLabel.textColor = .colorRedEB2727
            }
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
extension ItemView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ItemView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
