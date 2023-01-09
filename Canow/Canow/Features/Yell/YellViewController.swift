//
//  YellViewController.swift
//  Canow
//
//  Created by PhuNT14 on 17/11/2021.
//

import UIKit

class YellViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            if let stableToken = DataManager.shared.getStableTokenCustomer() {
                self.headerView.setTitle(title: stableToken.name)
            } else {
                self.headerView.setTitle(title: StringConstants.yell.localized)
            }
            self.headerView.backButtonHidden = true
        }
    }
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var landingPageContentView: UIView!
    @IBOutlet weak var balanceView: UIView! {
        didSet {
            self.balanceView.dropShadow()
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var showBalanceButton: UIButton!
    @IBOutlet weak var qrView: UIView! {
        didSet {
            self.qrView.dropShadow()
        }
    }
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            self.avatarImageView.configBorder(borderWidth: 4,
                                              borderColor: .white,
                                              cornerRadius: 32)
        }
    }
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var topupImageView: UIImageView!
    @IBOutlet weak var topupLabel: UILabel! {
        didSet {
            self.topupLabel.text = StringConstants.s04BtnTopup.localized
        }
    }
    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var payLabel: UILabel! {
        didSet {
            self.payLabel.text = StringConstants.s06LbPay.localized
        }
    }
    @IBOutlet weak var transferImageView: UIImageView!
    @IBOutlet weak var transferLabel: UILabel! {
        didSet {
            self.transferLabel.text = StringConstants.s05BtnTransfer.localized
        }
    }
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            self.bottomView.dropShadow()
        }
    }
    @IBOutlet weak var stableTokenImage: UIImageView! {
        didSet {
            self.stableTokenImage.rounded()
        }
    }
    @IBOutlet weak var loginNoticeLabel: UILabel! {
        didSet {
            self.loginNoticeLabel.font = .font(with: .medium500, size: 14)
            self.loginNoticeLabel.text = StringConstants.s07YourQRCode.localized
        }
    }
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.loginButton.setTitle(StringConstants.s01BtnLogin, for: .normal)
            self.loginButton.setTitle(StringConstants.s01BtnLogin, for: .highlighted)
        }
    }
    
    // MARK: - Properties
    let viewModel = YellViewModel()
    private var balance = "0" {
        didSet {
            self.updateBalanceView()
        }
    }
    private var shouldShowBalance = UserDefaultManager.showBalance ?? true {
        didSet {
            self.updateBalanceView()
        }
    }
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.getStableTokenSuccess()
        self.getMyQRSuccess()
        self.getStableMobileInfSuccess()
        self.fetchDataFailure()
    }
    
    override func updateTheme() {
        self.headerView.updateUI()
        if let bg = self.themeInfo.bgPattern2 {
            self.bgImageView.image = bg
            self.topupImageView.image = IconButton.topup.image
            self.transferImageView.image = IconButton.transfer.image
            self.payImageView.image = IconButton.pay.image
            
            self.topupImageView.setImageColor(self.themeInfo.buttonActionColor)
            self.transferImageView.setImageColor(self.themeInfo.buttonActionColor)
            self.payImageView.setImageColor(self.themeInfo.buttonActionColor)
        } else {
            self.bgImageView.image = UIImage(named: "bg_yell")
            self.topupImageView.image = IconButton.topup.imageDefault
            self.transferImageView.image = IconButton.transfer.imageDefault
            self.payImageView.image = IconButton.pay.imageDefault
        }
    }
    
}

// MARK: - Methods
extension YellViewController {
    
    private func updateUI() {
        if KeychainManager.apiIdToken() != nil {
            self.contentView.isHidden = false
            self.landingPageContentView.isHidden = true
            self.viewModel.fetchData()
            
            if let avatar = self.viewModel.getCustomerInfo()?.avatar {
                self.avatarImageView.kf.setImage(with: CommonManager.getImageURL(avatar), placeholder: UIImage(named: "ic_avatar"))
            }
        } else {
            self.contentView.isHidden = true
            self.landingPageContentView.isHidden = false
        }
        
        if let stableToken = DataManager.shared.getStableTokenCustomer() {
            self.headerView.setTitle(title: stableToken.name)
        } else {
            self.viewModel.getStableTokenDefault()
        }
    }
    
    func getStableTokenSuccess() {
        self.viewModel.getStableTokenSuccess = { balance in
            self.balance = balance
        }
        self.viewModel.getStableMobileDefaultSuccess = {
            self.headerView.setTitle(title: self.viewModel.stableTokenDefault?.name ?? "")
        }
    }
    
    func getMyQRSuccess() {
        self.viewModel.getMyQRSuccess = {
            self.convertBase64StringToImage(base64String: self.viewModel.myQRData)
        }
    }
    
    func getStableMobileInfSuccess() {
        self.viewModel.getStableMobileInfSuccess = {
            if let stableToken = self.viewModel.stableToken {
                self.stableTokenImage.kf.setImage(with: CommonManager.getImageURL(stableToken.logo))
            }
        }
    }
    
    func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            self.qrImageView.image = nil
            self.avatarImageView.image = nil
            self.balance = "0"
            CommonManager.hideLoading()
        }
    }
    
    private func convertBase64StringToImage(base64String: String) {
        if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            self.qrImageView.image = UIImage(data: imageData)
        }
    }
    
    private func changeEye(_ enable: Bool) {
        let image = UIImage(named: enable ? "ic_eye_close" : "ic_eye")
        self.showBalanceButton.setImage(image, for: .normal)
        self.showBalanceButton.setImage(image, for: .highlighted)
    }
    
    private func updateBalanceView() {
        self.balanceLabel.text = self.shouldShowBalance ? self.balance : "******"
        self.changeEye(self.shouldShowBalance)
    }
    
}

// MARK: - Actions
extension YellViewController {
    
    @IBAction func actionShowBalance(_ sender: Any) {
        self.shouldShowBalance.toggle()
    }
    
    @IBAction func actionTopup(_ sender: Any) {
        let topupVC = TopupViewController()
        topupVC.hidesBottomBarWhenPushed = true
        self.push(viewController: topupVC)
    }
    
    @IBAction func actionPay(_ sender: Any) {
        self.openCamera(checkPermissionOnly: true) { _ in
            let scanQRViewController = ScanQRViewController()
            scanQRViewController.transactionType = .pay
            self.push(viewController: scanQRViewController)
        }
        
    }
    
    @IBAction func actionTransfer(_ sender: Any) {
        let transferViewController = TransferFanTokenViewController()
        self.push(viewController: transferViewController)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.push(viewController: LoginViewController())
    }
    
}

extension YellViewController: ScanQRDelegate {
    
    func scanResult<T>(model: T) {
        if let merchant = model as? QRPayByST {
            if merchant.amount == 0 {
                self.push(viewController: PayViewController(model: merchant))
            } else {
                let inputAmount = InputAmountTransactionViewController(transactionType: .pay)
                inputAmount.merchantInfo = merchant
                inputAmount.payType = .payPremoney
                self.push(viewController: inputAmount)
            }
        }
    }

}
