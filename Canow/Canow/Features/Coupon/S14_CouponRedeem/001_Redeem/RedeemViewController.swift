//
//  RedeemViewController.swift
//  Canow
//
//  Created by NhanTT13 on 12/7/21.
//

import UIKit

class RedeemViewController: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s07RedeemCoupon)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet weak var imageCoupon: UIImageView!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var availableTillLabel: UILabel!
    @IBOutlet weak var validTillLabel: UILabel!
    @IBOutlet weak var priceCouponLabel: UILabel!
    @IBOutlet weak var itemImageCoupon: UIImageView!
    @IBOutlet weak var itemMerchantNameLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageErrCodeLabel: UILabel!
    @IBOutlet weak var exchangeNowLinkLabel: UILabel! {
        didSet {
            self.exchangeNowLinkLabel.underline()
            self.exchangeNowLinkLabel.text = StringConstants.exchangeNow
        }
    }
    
    // MARK: - Properties
    var viewModel = RedeemViewModel()
    var eCouponId: String = ""
    var fanTokenBalance: Int = 0
    var couponPrice: Int = 0
    
    var partnerId: Int = 0
    var tokenName: String = ""
    var urlImagePartner: String = ""
    var teamFantokenTicker: String = ""
    var fanTokenBalanceTeamSelect: Int = 0
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        self.reloadData()
    }
}

// MARK: - Actions
extension RedeemViewController {
    @IBAction func redeemButton(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: StringConstants.ok, style: .default) { _ in
            if self.couponPrice > self.fanTokenBalance {
                self.messageErrCodeLabel.isHidden = false
                self.messageErrCodeLabel.text = "Your balance is \(self.fanTokenBalance) \(self.viewModel.couponDetail?.teamFantokenTicker ?? "") "
                self.exchangeNowLinkLabel.isHidden = false
            } else {
                self.viewModel.couponRedeem(eCouponId: self.eCouponId)
                self.transactionStatus()
            }
        }
        guard let image = UIImage(named: "ic_confirm") else { return }
        alertVC.addImage(image: image)
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Methods
extension RedeemViewController {
    func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exchangeNow))
        self.exchangeNowLinkLabel.isUserInteractionEnabled = true
        self.exchangeNowLinkLabel.addGestureRecognizer(tapGesture)
    }
    
    func setupData() {
        self.viewModel.getCouponDetail(eCouponId: eCouponId)
    }
    
    func reloadData() {
        self.viewModel.getCouponDetailSuccess = {
            self.couponNameLabel.text = self.viewModel.couponDetail?.couponName
            if let couponImage = CommonManager.getImageURL(self.viewModel.couponDetail?.image ?? ""),
               let merchantLogo = CommonManager.getImageURL(self.viewModel.couponDetail?.merchantLogo ?? "") {
                self.imageCoupon.kf.setImage(with: couponImage)
                self.itemImageCoupon.kf.setImage(with: merchantLogo)
            }
            self.availableTillLabel.text = "Available till: \( self.viewModel.couponDetail?.availableTo.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? "") "
            self.validTillLabel.text = "Valid till: \( self.viewModel.couponDetail?.expiredDate.toDate(dateFormat: DateFormat.DATE_CURRENT)?.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT) ?? "")"
            self.priceCouponLabel.text = "\(self.viewModel.couponDetail?.price ?? 0) \(self.viewModel.couponDetail?.teamFantokenTicker ?? "")"
            self.itemMerchantNameLabel.text = self.viewModel.couponDetail?.merchantName
            self.itemNameLabel.text = self.viewModel.couponDetail?.itemName
            self.itemPriceLabel.text = "\(self.viewModel.couponDetail?.payPrice ?? 0) \(UserDefaultManager.tokenName ?? "")"
            self.descriptionLabel.text = self.viewModel.couponDetail?.description.htmlToString
            self.couponPrice = self.viewModel.couponDetail?.price ?? 0
            self.teamFantokenTicker = self.viewModel.couponDetail?.teamFantokenTicker ?? ""
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.checkAuthenticateError(error)
        }
        
        self.viewModel.getCouponDetailFailure = { error in
            CommonManager.checkAuthenticateError(error)
        }
        
        self.viewModel.transactionFailure = { error in
            CommonManager.checkAuthenticateError(error)
        }
    }
    
    @objc private func exchangeNow(sender: UITapGestureRecognizer) {
        let inputAmountVC = InputAmountViewController()
        inputAmountVC.tokenName = tokenName
        inputAmountVC.partnerId = partnerId
        inputAmountVC.urlImagePartner = urlImagePartner
        inputAmountVC.fanTokenBalanceTeamSelect = fanTokenBalanceTeamSelect
        self.push(viewController: inputAmountVC)
    }
    
    func transactionStatus() {
        self.viewModel.fetchDataSuccess = { transactionId in
            let viewController = TransactionStatusViewController()
            viewController.transactionId = transactionId
            viewController.transactionType = .redeemCoupon
            viewController.teamFantokenTickerRedeem = self.teamFantokenTicker
            self.push(viewController: viewController)
        }
    }
}
