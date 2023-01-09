//
//  ItemRedeemView.swift
//  Canow
//
//  Created by hieplh2 on 04/01/2022.
//

import UIKit

class ItemRedeemView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            self.itemImageView.configBorder(borderWidth: 1,
                                            borderColor: .colorE5E5E5,
                                            cornerRadius: 6)
        }
    }
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var usableLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var progressView: ProgressRedeemView!
    @IBOutlet weak var usableFromLabel: UILabel! {
        didSet {
            self.usableFromLabel.text = StringConstants.s14EndOfSale.localized
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
    var usableDate: String? {
        didSet {
            self.usableLabel.text = self.usableDate
        }
    }
    var expireDate: String? {
        didSet {
            self.expiryLabel.text = self.expireDate
        }
    }
    var progressCurrent: Int = 0 {
        didSet {
            self.progressView.current = self.progressCurrent
        }
    }
    var progressTotal: Int = 0 {
        didSet {
            self.progressView.total = self.progressTotal
        }
    }
    
    var progressRemaining: Int = 0 {
        didSet {
            self.progressView.remaining = self.progressRemaining
        }
    }
    var usableFromTitle: String = "" {
        didSet {
            self.usableFromLabel.text = self.usableFromTitle
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.frame
        frame.size.width -= 32
        self.progressView.frame = frame
        self.progressView.current = self.progressCurrent
        self.progressView.total = self.progressTotal
        self.progressView.remaining = self.progressRemaining
    }
    
}

// MARK: - Methods
extension ItemRedeemView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ItemRedeemView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
