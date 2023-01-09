//
//  ExchangeConfirmView.swift
//  Canow
//
//  Created by NhanTT13 on 1/19/22.
//

import UIKit

class ExchangeConfirmView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak var transactionTitle: UILabel! {
        didSet {
            self.transactionTitle.text = StringConstants.s05TransactionConfirm.localized
            self.transactionTitle.font = .font(with: .bold700, size: 14)
            self.transactionTitle.textColor = .color646464
        }
    }
    @IBOutlet weak var fantokenImage: UIImageView! {
        didSet {
            self.fantokenImage.rounded()
        }
    }
    @IBOutlet weak var amountExchangeLabel: UILabel! {
        didSet {
            self.amountExchangeLabel.textColor = .colorBlack111111
            self.amountExchangeLabel.font = .font(with: .bold700, size: 30)
        }
    }
    @IBOutlet weak var exchangeDetailLabel: UILabel! {
        didSet {
            self.exchangeDetailLabel.text = StringConstants.s13LbExchangeDetail.localized
            self.exchangeDetailLabel.textColor = .colorBlack111111
            self.exchangeDetailLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var userInfoImage: UIImageView! {
        didSet {
            self.userInfoImage.rounded()
        }
    }
    @IBOutlet weak var userInfoNameLabel: UILabel! {
        didSet {
            self.userInfoNameLabel.textColor = .colorBlack111111
            self.userInfoNameLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet weak var userInfoPhoneLabel: UILabel! {
        didSet {
            self.userInfoPhoneLabel.textColor = .color646464
            self.userInfoPhoneLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var equivalenToLabel: UILabel! {
        didSet {
            self.equivalenToLabel.text = StringConstants.s04EquivalentTo.localized
            self.equivalenToLabel.textColor = .color646464
            self.equivalenToLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var stableTokenImage: UIImageView! {
        didSet {
            self.stableTokenImage.rounded()
        }
    }
    @IBOutlet weak var stableTokenBalanceLabel: UILabel! {
        didSet {
            self.stableTokenBalanceLabel.textColor = .black
            self.stableTokenBalanceLabel.font = .font(with: .bold700, size: 12)
        }
    }
    
    // MARK: - Properties
    var imageFT: String = "" {
        didSet {
            self.fantokenImage.kf.setImage(with: CommonManager.getImageURL(imageFT))
        }
    }
    
    var amountExchange: Int = 0 {
        didSet {
            self.amountExchangeLabel.text = "\(amountExchange)".formatPrice()
        }
    }
    
    var userImage: String = "" {
        didSet {
            self.userInfoImage.kf.setImage(with: CommonManager.getImageURL(userImage))
        }
    }
    
    var userName: String = "" {
        didSet {
            self.userInfoNameLabel.text = self.userName
        }
    }
    
    var userPhone: String = "" {
        didSet {
            self.userInfoPhoneLabel.text = self.userPhone
        }
    }
    
    var imageST: String = "" {
        didSet {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(imageST))
        }
    }
    
    var balanceUser: Int = 0 {
        didSet {
            self.stableTokenBalanceLabel.text = "\(balanceUser)".formatPrice()
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
extension ExchangeConfirmView {
    private func commonInit() {
        Bundle.main.loadNibNamed("ExchangeConfirmView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
}
