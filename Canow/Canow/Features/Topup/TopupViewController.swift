//
//  TopupViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/15/21.
//
//  Screen ID: S05000

import UIKit

class TopupViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s04TitleHeader.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    
    @IBOutlet weak var balanceImageView: UIImageView!
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.backgroundColor = .white
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var topUpViaCardView: UIView! {
        didSet {
            self.topUpViaCardView.layer.cornerRadius = 8
            self.topUpViaCardView.dropShadow(color: UIColor.black,
                                             opacity: 0.1,
                                             offSet: CGSize(width: 0, height: 4),
                                             radius: 16)
            let tapVisa = UITapGestureRecognizer(target: self, action: #selector(topUpViaCard))
            self.topUpViaCardView.addGestureRecognizer(tapVisa)
        }
    }
    
    @IBOutlet private weak var topUpGiftCardView: UIView! {
        didSet {
            self.topUpGiftCardView.layer.cornerRadius = 8
            self.topUpGiftCardView.dropShadow(color: UIColor.black,
                                              opacity: 0.1,
                                              offSet: CGSize(width: 0, height: 4),
                                              radius: 16)
            let tapGiftCard = UITapGestureRecognizer(target: self, action: #selector(topUpGiftCard))
            self.topUpGiftCardView.addGestureRecognizer(tapGiftCard)
        }
    }
    @IBOutlet private weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.textColor = .colorBlack111111
            self.balanceLabel.font = .font(with: .bold700, size: 24)
        }
    }
    @IBOutlet private weak var visaCardLabel: UILabel! {
        didSet {
            self.visaCardLabel.textColor = .colorBlack111111
            self.visaCardLabel.font = .font(with: .medium500, size: 16)
            self.visaCardLabel.text = StringConstants.s04VisaCard.localized
        }
    }
    @IBOutlet private weak var giftCardLabel: UILabel! {
        didSet {
            self.giftCardLabel.textColor = .colorBlack111111
            self.giftCardLabel.font = .font(with: .medium500, size: 16)
            self.giftCardLabel.text = StringConstants.s04GiftCard.localized
        }
    }
    @IBOutlet private weak var yourBanaceLabel: UILabel! {
        didSet {
            self.yourBanaceLabel.textColor = self.themeInfo.unselectedTabColor
            self.yourBanaceLabel.font = .font(with: .medium500, size: 14)
            self.yourBanaceLabel.text = StringConstants.s04YourBanance.localized
        }
    }
    @IBOutlet weak var stableTokenImage: UIImageView! {
        didSet {
            self.stableTokenImage.rounded()
        }
    }
    
    // MARK: - Variables
    private var viewModel = TopupViewModel()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
        
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        reloadData()
        fetchDataFailure()
    }
    
    override func updateTheme() {
        self.balanceImageView.image = self.themeInfo.bgPattern6
        self.balanceLabel.textColor = self.themeInfo.textColor
        self.yourBanaceLabel.textColor = self.themeInfo.textColor.withAlphaComponent(0.5)
    }
    
}

// MARK: - Methods
extension TopupViewController {
    
    private func updateUI() {
        self.viewModel.getStableTokenCustomer()
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = { stableTokenCustomer in
            self.balanceLabel.text = "\(stableTokenCustomer.balance ?? 0)".formatPrice()
        }
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            if error == StringConstants.ERROR_CODE_401 || error == StringConstants.ERROR_CODE_403 {
                NotificationCenter.default.post(name: NSNotification.authenticateError, object: nil)
            }
        }
    }
}

// MARK: - Actions
extension TopupViewController {
    
    @objc func topUpViaCard(_ sender: UITapGestureRecognizer) {
        self.push(viewController: InputAmountTransactionViewController(transactionType: .topUp))
    }
    
    @objc func topUpGiftCard(_ sender: UITapGestureRecognizer) {
        self.push(viewController: TopupGiftCardViewController())
    }
    
}
