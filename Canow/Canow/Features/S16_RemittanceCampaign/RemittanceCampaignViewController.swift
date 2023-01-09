//
//  RemittanceCampaignViewController.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import UIKit
import Kingfisher

class RemittanceCampaignViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s10TitleRemittanceDetail.localized)
            self.headerView.bgColor = .clear
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet weak var raisedTitleLabel: UILabel! {
        didSet {
            self.raisedTitleLabel.text = StringConstants.s10LbRaised.localized
        }
    }
    @IBOutlet weak var lineView: UIView! {
        didSet {
            self.lineView.backgroundColor = .color000000Alpha10
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var banlanceView: UIView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var remittanceImage: UIImageView! {
        didSet {
            self.remittanceImage.rounded()
        }
    }
    @IBOutlet private weak var totalDonateLabel: UILabel!
    @IBOutlet weak var fantokenLogoImageView: UIImageView! {
        didSet {
            self.fantokenLogoImageView.rounded()
        }
    }
    @IBOutlet weak var balanceBackgroundImageView: UIImageView!
    @IBOutlet private weak var remittanceNameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.text = StringConstants.s14Balance.localized
        }
    }
    @IBOutlet private weak var descriptionLabel: MoreLessLabel! {
        didSet {
            self.descriptionLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var totalBackerTitleLabel: UILabel! {
        didSet {
            self.totalBackerTitleLabel.text = StringConstants.s10LbBacker.localized
            self.totalBackerTitleLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var totalBackerLabel: UILabel! {
        didSet {
            self.totalBackerLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var dueDateTitleLabel: UILabel! {
        didSet {
            self.dueDateTitleLabel.text = StringConstants.s17LbDueDate.localized
            self.dueDateTitleLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var dueDateLabel: UILabel! {
        didSet {
            self.dueDateLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var campaignItemCollectiView: UICollectionView! {
        didSet {
            self.campaignItemCollectiView.delegate = self
            self.campaignItemCollectiView.dataSource = self
            self.campaignItemCollectiView.registerReusedCell(cellNib: RemittanceItemCell.self)
        }
    }
    @IBOutlet private weak var donateNowButton: CustomButton! {
        didSet {
            self.donateNowButton.setTitle(StringConstants.donateNow.localized, for: .normal)
            self.donateNowButton.setTitle(StringConstants.donateNow.localized, for: .highlighted)
            self.donateNowButton.disable()
        }
    }
    @IBOutlet weak var fantokenLogoBalanceImage: UIImageView! {
        didSet {
            self.fantokenLogoBalanceImage.rounded()
        }
    }
    @IBOutlet weak var balanOfPartnerLabel: UILabel!
    
    // MARK: - Properties
    let viewModel = RemittanceCampaignViewModel()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    var cellSelectedIndex: Int?
    var remittanceId: Int = 0
    var heightCell: Int = 85
    var imageFantoken: String = ""
    var fanTokenBalance: Int = 0
    var remittancePrice: Int = 0
    var amountItemOops: Int = 0
    
    var partnerId: Int = 0
    var tokenName: String = ""
    var urlImagePartner: String = ""
    var fanTokenBalanceTeamSelect: Int = 0
    
    var remittanceAmountConfirm: Int = 0
    var remittanceToAvatarConfirm: String = ""
    var remittanceItemNameConfirm: String = ""
    var remittanceNameLabelConfirm: String = ""
    var remittanceCampaignItemIdConfirm: Int = 0
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.setupData()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
    override func updateTheme() {
        self.balanceBackgroundImageView.image = {
            if let background = self.themeInfo.bgPattern7 {
                return background
            } else {
                return UIImage(named: "bg_balance_remittance")
            }
        }()
        self.balanceLabel.textColor = self.themeInfo.textColor.withAlphaComponent(0.5)
        self.balanOfPartnerLabel.textColor = self.themeInfo.textColor
    }
    
}

// MARK: - Methods
extension RemittanceCampaignViewController {
    
    private func setupUI() {
        self.balanOfPartnerLabel.text = "\(self.fanTokenBalance)".formatPrice()
        self.banlanceView.isHidden = KeychainManager.apiIdToken() == nil
    }
    
    private func setupData() {
        CommonManager.showLoading()
        self.viewModel.getRemittanceCampaign(remittanceId: remittanceId)
        self.viewModel.getCampaignItem()
        self.viewModel.getTeamInfoSelected(partnerId: self.partnerId)
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
            if let remittance = self.viewModel.remittanceCampaign {
                self.remittanceImage.kf.setImage(with: CommonManager.getImageURL(remittance.image))
                self.fantokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(remittance.fantokenLogo))
                self.fantokenLogoBalanceImage.kf.setImage(with: CommonManager.getImageURL(remittance.fantokenLogo))
                self.totalDonateLabel.text = remittance.totalAmount?.formatPrice()
                self.remittanceNameLabel.text = remittance.name ?? ""
                self.descriptionLabel.numOfLines = 3
                self.descriptionLabel.fullText = remittance.description?.htmlToString.replacingOccurrences(of: "\n", with: "")
                self.totalBackerLabel.text = remittance.totalBacker ?? ""
                self.dueDateLabel.text = remittance.availableTo?.formatDateString(DateFormat.DATE_CURRENT, DateFormat.DATE_FORMAT_CROWDFUNDING)
                self.imageFantoken = remittance.fantokenLogo ?? ""
                self.remittanceNameLabelConfirm = remittance.name ?? ""
            }
            self.campaignItemCollectiView.reloadData()
        }
        
        self.viewModel.fetchRemittanceItemSuccess = {
            CommonManager.hideLoading()
            self.campaignItemCollectiView.reloadData()
        }
        
        self.viewModel.checkWhenDonateSuccess = {
            self.checkPushDataToConfirm()
            CommonManager.hideLoading()
        }
        
        self.viewModel.fetchTeamSelected = { partnerInfo in
            CommonManager.hideLoading()
            self.urlImagePartner = partnerInfo.logo
            self.tokenName = partnerInfo.stableTokenName ?? ""
            self.fanTokenBalanceTeamSelect = partnerInfo.fanTokenBalance
            self.viewModel.getCustomerBalance(tokenType: partnerInfo.fantokenTicker)
        }
        
        self.viewModel.fetchFantokenBalanceInfo = { fantokenInfo in
            self.fanTokenBalance = fantokenInfo?.fanTokenBalance ?? 0
            self.balanOfPartnerLabel.text = "\(self.fanTokenBalance)".formatPrice()
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
        
        self.viewModel.checkWhenDonateFailure = { err in
            CommonManager.hideLoading()
            switch err {
            case MessageCode.E017.message:
                self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                               message: StringConstants.s17MessageExchange.localized,
                               popupBg: UIImage(named: "bg_yourBalance"),
                               leftButton: (StringConstants.s01BtnCancel.localized, {}),
                               rightButton: (StringConstants.s17BtnExchange.localized, {
                    guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
                        return
                    }
                    let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
                    inputAmountVC.partnerId = partnerInfo.id
                    inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo ?? ""
                    self.push(viewController: inputAmountVC) }))
            case MessageCode.E065.message:
                self.showPopup(title: err,
                               message: StringConstants.s10E065Message.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.viewControllers.forEach({ (vc) in
                        if  let homePageViewController = vc as? HomePageViewController {
                            self.popTo(viewController: homePageViewController)
                        }
                    })
                }))
            case MessageCode.E109.message:
                self.showPopup(title: MessageCode.E065.message,
                               message: StringConstants.s10E065Message.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.setupUI()
                    self.setupData()
                }))
            default:
                self.showPopup(title: err,
                               message: StringConstants.s17MessageCheckAgain.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, { self.pop() }))
            }
        }
        
        self.viewModel.getCustomerBalanceFailure = { _ in
            self.banlanceView.isHidden = true
        }
    }
    
    private func changeButtonState(_ enable: Bool) {
        if enable {
            self.donateNowButton.enable()
        } else {
            self.donateNowButton.disable()
        }
    }
    
    private func pushExchangeNow() {
        guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
            return
        }
        let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
        inputAmountVC.partnerId = partnerInfo.id
        inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo!
        self.push(viewController: inputAmountVC)
    }
    
    private func checkPushDataToConfirm() {
        let confirmVC = TransactionConfirmViewController(transactionType: .remittance)
        
        if let index = cellSelectedIndex {
            self.remittanceCampaignItemIdConfirm = self.viewModel.remittanceItemList[index].id ?? 0
            self.remittanceAmountConfirm = self.viewModel.remittanceItemList[index].price ?? 0
            self.remittanceToAvatarConfirm = self.viewModel.remittanceItemList[index].icon ?? ""
            self.remittanceItemNameConfirm = self.viewModel.remittanceItemList[index].name ?? ""
            confirmVC.cellSelectedIndex = index
        }
        
        confirmVC.fanTokenLogo = self.imageFantoken
        confirmVC.remittanceToAvatar = self.remittanceToAvatarConfirm
        confirmVC.remittanceItemAmount = self.remittanceAmountConfirm
        confirmVC.remittanceItemName = self.remittanceItemNameConfirm
        confirmVC.remittanceNameLabel = self.remittanceNameLabelConfirm
        confirmVC.remittanceCampaignId = self.remittanceId
        confirmVC.remittanceCampaignItemId = self.remittanceCampaignItemIdConfirm
        self.push(viewController: confirmVC)
    }
    
}

// MARK: - Actions
extension RemittanceCampaignViewController {
    
    @IBAction func donateNowAction(_ sender: CustomButton) {
        if !CommonManager.checkLandingPage() {
            return
        }
        self.viewModel.getRemittanceCampaign(remittanceId: remittanceId)
        if let index = cellSelectedIndex {
            CommonManager.showLoading()
            let campaignItemId = self.viewModel.remittanceItemList[index].id ?? 0
            let price = self.viewModel.remittanceItemList[index].price ?? 0
            self.viewModel.checkWhenDonate(campaignId: remittanceId,
                                           campaignItemId: campaignItemId,
                                           price: price)
        } else {
            self.campaignItemCollectiView.reloadData()
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RemittanceCampaignViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.remittanceItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellNib: RemittanceItemCell.self, indexPath: indexPath)
        let data = self.viewModel.remittanceItemList[indexPath.row]
        cell?.configure(data: data)
        // self.amountItemOops = Int((cell?.remittantItemPrice.text)!)!
        cell?.configureImage(urlImage: self.imageFantoken)
        cell?.isCellSelected = self.cellSelectedIndex == indexPath.row
        return cell ?? BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.isEmpty == false {
            self.changeButtonState(true)
        } else {
            self.changeButtonState(false)
        }
        self.cellSelectedIndex = indexPath.row
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.campaignItemCollectiView.frame.size.width), height: heightCell)
    }
    
}
