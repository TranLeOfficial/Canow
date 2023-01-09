//
//  HomePageViewController.swift
//  Canow
//
//  Created by PhucNT34 on 1/11/22.
//

import UIKit
import Kingfisher

enum FanTokenOrHome {
    case fanToken
    case home
    case redEnvelope
}
class HomePageViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.backButtonHidden = true
            self.headerView.rightButtonHidden = false
            self.headerView.rightButtonImage = UIImage(named: "ic_ring")
            self.headerView.onPressRightButton = {
                let newListVC = NewsListViewController()
                self.push(viewController: newListVC)
            }
            self.headerView.onBack = {
                switch DataManager.shared.isFanToken() {
                case .redEnvelope:
                    self.popToRoot()
                    NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                default:
                    self.pop()
                }
                DataManager.shared.saveCheck(check: .home)
            }
        }
    }
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var iconView: UIView! {
        didSet {
            self.iconView.clipsToBounds = true
            self.iconView.layer.cornerRadius = self.iconView.frame.height/2
            self.iconView.backgroundColor = .clear
        }
    }
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            self.iconImageView.backgroundColor = .clear
            self.iconImageView.rounded()
        }
    }
    @IBOutlet private weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.text = StringConstants.s14Balance.localized
            self.balanceLabel.textColor = self.themeInfo.unselectedTabColor
            self.balanceLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var iconLittleView: UIView! {
        didSet {
            self.iconLittleView.clipsToBounds = true
            self.iconLittleView.layer.cornerRadius = self.iconLittleView.frame.height/2
            self.iconLittleView.backgroundColor = .clear
        }
    }
    @IBOutlet private weak var iconLitlteImageView: UIImageView! {
        didSet {
            self.iconLitlteImageView.backgroundColor = .clear
            self.iconLitlteImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var moneyDonateLabel: UILabel! {
        didSet {
            self.moneyDonateLabel.font = .font(with: .bold700, size: 24)
            self.moneyDonateLabel.textColor = self.themeInfo.textColor
        }
    }
    @IBOutlet private weak var controlButtonView: UIView! {
        didSet {
            self.controlButtonView.layer.cornerRadius = 6
            self.controlButtonView.dropShadow()
        }
    }
    @IBOutlet private weak var boderControlButtonStackView: UIStackView! {
        didSet {
            self.boderControlButtonStackView.backgroundColor = .colorE5E5E5
        }
    }
    @IBOutlet private weak var exchangeImageView: UIImageView! {
        didSet {
            self.exchangeImageView.image = UIImage(named: "ic_exchange")
        }
    }
    @IBOutlet private weak var exchangeLabel: UILabel! {
        didSet {
            self.exchangeLabel.font = .font(with: .medium500, size: 12)
            self.exchangeLabel.text = StringConstants.s11BtnExchange.localized
        }
    }
    @IBOutlet private weak var transferImageView: UIImageView! {
        didSet {
            self.transferImageView.image = UIImage(named: "ic_transfer")
        }
    }
    @IBOutlet private weak var transferLabel: UILabel! {
        didSet {
            self.transferLabel.font = .font(with: .medium500, size: 12)
            self.transferLabel.text = StringConstants.s11BtnTransfer.localized
        }
    }
    @IBOutlet private weak var informationImageView: UIImageView! {
        didSet {
            self.informationImageView.image = UIImage(named: "ic_information")
        }
    }
    @IBOutlet private weak var informationLabel: UILabel! {
        didSet {
            self.informationLabel.font = .font(with: .medium500, size: 12)
            self.informationLabel.text = StringConstants.s11BtnInfomation.localized
        }
    }
    @IBOutlet private weak var bodyView: UIView! {
        didSet {
            self.bodyView.layer.cornerRadius = 16
        }
    }
    @IBOutlet private weak var menuActionStackView: UIStackView!
    @IBOutlet private weak var couponButton: UIButton! {
        didSet {
            self.couponButton.setTitle(StringConstants.s11LbCoupon.localized, for: .normal)
            self.couponButton.setTitle(StringConstants.s11LbCoupon.localized, for: .highlighted)
            self.couponButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.couponButton.tintColor = self.themeInfo.textColor
        }
    }
    @IBOutlet private weak var crowdFundingButton: UIButton! {
        didSet {
            self.crowdFundingButton.setTitle(StringConstants.s11LbCrowdfunding.localized, for: .normal)
            self.crowdFundingButton.setTitle(StringConstants.s11LbCrowdfunding.localized, for: .highlighted)
            self.crowdFundingButton.titleLabel?.font = .font(with: .medium500, size: 14)
            self.crowdFundingButton.tintColor = self.themeInfo.unselectedTabColor
            self.crowdFundingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet private weak var remittanceButton: UIButton! {
        didSet {
            self.remittanceButton.setTitle(StringConstants.s11LbRemittance.localized, for: .normal)
            self.remittanceButton.setTitle(StringConstants.s11LbRemittance.localized, for: .highlighted)
            self.remittanceButton.titleLabel?.font = .font(with: .medium500, size: 14)
            self.remittanceButton.tintColor = self.themeInfo.unselectedTabColor
        }
    }
    @IBOutlet private weak var couponView: UIView! {
        didSet {
            self.couponView.backgroundColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var crowdFundingView: UIView! {
        didSet {
            self.crowdFundingView.backgroundColor = .colorBlack111111
            self.crowdFundingView.isHidden = true
        }
    }
    @IBOutlet private weak var remittanceView: UIView! {
        didSet {
            self.remittanceView.backgroundColor = .colorBlack111111
            self.remittanceView.isHidden = true
        }
    }
    @IBOutlet private weak var exchangeButton: UIButton! {
        didSet {
            self.exchangeButton.setTitle("", for: .normal)
            self.exchangeButton.setTitle("", for: .highlighted)
        }
    }
    @IBOutlet private var tranferButton: UIButton! {
        didSet {
            self.tranferButton.setTitle("", for: .normal)
            self.tranferButton.setTitle("", for: .highlighted)
        }
    }
    @IBOutlet private weak var informationButton: UIButton! {
        didSet {
            self.informationButton.setTitle("", for: .normal)
            self.informationButton.setTitle("", for: .highlighted)
        }
    }
    
    // MARK: - Properties
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    private let viewModel = HomePageViewModel()
    private var currentIndex = 0
    var checkFantokenPush: FanTokenOrHome = .home
    private var viewControllers = [UIViewController]()
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        return pageViewController
    }()
    private lazy var homeCouponVC: HomeCouponViewController = {
        let homeCouponVC = HomeCouponViewController()
        return homeCouponVC
    }()
    private lazy var homeCrowdfundingVC: HomeCrowdfundingViewController = {
        let homeCrowdfundingVC = HomeCrowdfundingViewController()
        return homeCrowdfundingVC
    }()
    private lazy var homeRemittanceVC: HomeRemittanceViewController = {
        let homeRemittanceVC = HomeRemittanceViewController()
        return homeRemittanceVC
    }()
    private lazy var segmentButtonGroup: [UIButton] = {
        let segmentButtonGroup: [UIButton] = [self.couponButton, self.crowdFundingButton, remittanceButton]
        return segmentButtonGroup
    }()
    private lazy var segmentViewGroup: [UIView] = {
        let segmentViewGroup: [UIView] = [self.couponView, self.crowdFundingView, self.remittanceView]
        return segmentViewGroup
    }()
    private var teamFavoriteId: Int?
    private var fanTokenBalance: Int = 0
    var fantokenLogo: String = ""
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkLogin()
        self.setupUniversalLink()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.authenticateError),
                                               name: NSNotification.authenticateError,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.backHomePage),
                                               name: NSNotification.backHomePage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.login),
                                               name: NSNotification.Login,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.universalLink),
                                               name: NSNotification.universalLink,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.authenticateError, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.backHomePage, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Login, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.universalLink, object: nil)
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
    override func updateTheme() {
        self.setupTheme()
    }
    
}

// MARK: - Methods
extension HomePageViewController {
    
    private func changeSegment(to index: Int) {
        self.pageViewController.setViewControllers([self.getViewController(at: index)!],
                                                   direction: self.currentIndex <= index ? .forward : .reverse,
                                                   animated: true)
        self.currentIndex = index
    }
    
    private func getViewController(at index: Int) -> UIViewController? {
        if self.viewControllers.isEmpty || index >= self.viewControllers.count {
            return nil
        }
        return self.viewControllers[index]
    }
    
    private func setupPageController() {
        self.viewControllers = [
            self.homeCouponVC,
            self.homeCrowdfundingVC,
            self.homeRemittanceVC
        ]
        
        if let firstViewController = self.getViewController(at: 0) {
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.menuActionStackView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.pageViewController.didMove(toParent: self)
    }
    
    private func setChangeUIButtonWhenChangeSegment(tag index: Int) {
        for view in self.segmentViewGroup {
            view.isHidden = view.tag != index
        }
    }
    
    private func fetchData() {
        switch self.checkFantokenPush {
        case .home:
            guard let customerInfo = DataManager.shared.getCustomerInfo() else {
                return
            }
            self.headerView.setTitle(title: customerInfo.team)
            self.viewModel.fetchData(partnerId: customerInfo.teamId)
        case .fanToken, .redEnvelope:
            self.headerView.backButtonHidden = false
            self.headerView.rightButtonHidden = true
            guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
                return
            }
            self.headerView.setTitle(title: partnerInfo.name)
            self.iconImageView.kf.setImage(with:CommonManager.getImageURL(partnerInfo.logo))
            self.iconLitlteImageView.kf.setImage(with:CommonManager.getImageURL(partnerInfo.fantokenLogo))
            self.viewModel.getCustomerBalance(tokenType: partnerInfo.fantokenTicker)
        }
    }
    
    private func reloadData() {
        self.viewModel.fetchTeamSelected = { teamInfo in
            self.iconImageView.kf.setImage(with:CommonManager.getImageURL(teamInfo.logo))
            self.iconLitlteImageView.kf.setImage(with:CommonManager.getImageURL(teamInfo.fantokenLogo))
            self.viewModel.getCustomerBalance(tokenType: teamInfo.fantokenTicker)
            self.viewModel.getStableTokenCustomerMobile()
        }
        
        self.viewModel.fetchFantokenBalanceInfo = { fantokenInfo  in
            if let fanTokenBalance = fantokenInfo?.fanTokenBalance {
                self.moneyDonateLabel.text = String(fanTokenBalance).formatPrice()
                self.fanTokenBalance = fanTokenBalance
            } else {
                self.moneyDonateLabel.text = "0"
            }
        }
    }
    
    private func setupTheme() {
        self.balanceLabel.textColor = self.themeInfo.textColor.withAlphaComponent(0.5)
        self.moneyDonateLabel.textColor = self.themeInfo.textColor
        self.backgroundImageView.image = self.themeInfo.bgPattern1
        self.segmentButtonGroup.forEach({
            $0.tintColor = self.currentIndex == $0.tag ? self.themeInfo.textColor : self.themeInfo.textColor.withAlphaComponent(0.5)
        })
        self.segmentViewGroup.forEach({
            $0.backgroundColor = self.themeInfo.textColor
        })
        if self.themeInfo.bgPattern1 != nil {
            self.bodyView.backgroundColor = .clear
            self.exchangeImageView.image = IconButton.exchange.image
            self.transferImageView.image = IconButton.transfer.image
            self.informationImageView.image = IconButton.info.image
            
            self.exchangeImageView.setImageColor(self.themeInfo.buttonActionColor)
            self.transferImageView.setImageColor(self.themeInfo.buttonActionColor)
            self.informationImageView.setImageColor(self.themeInfo.buttonActionColor)
        } else {
            self.bodyView.backgroundColor = .white
            self.exchangeImageView.image = IconButton.exchange.imageDefault
            self.transferImageView.image = IconButton.transfer.imageDefault
            self.informationImageView.image = IconButton.info.imageDefault
        }
    }
    
    private func checkLogin() {
        if KeychainManager.apiIdToken() == nil {
            self.iconImageView.image = UIImage()
            self.iconLitlteImageView.image = UIImage()
            self.moneyDonateLabel.text = ""
            self.headerView.setTitle(title: "")
            self.balanceLabel.text = ""
            DelegateManager.shared.setRootViewController(TabBarViewController(type: .landingPage))
        } else {
            self.balanceLabel.text = StringConstants.s14Balance.localized
            self.fetchData()
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            if error == MessageCode.E012.message {
                self.moneyDonateLabel.text = "0"
            }
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func setupUniversalLink() {
        if let universalLink = DataManager.shared.getUniversalLinkData() {
            switch universalLink.type {
            case .redEnvelope:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let eventId = universalLink.eventId {
                        let rewardViewController = RewardViewController()
                        rewardViewController.idEvent = eventId
                        self.push(viewController: rewardViewController)
                        DataManager.shared.deleteUniversalLinkData()
                    }
                }
            default:
                break
            }
        }
    }

}

// MARK: - Actions
extension HomePageViewController {
    
    @IBAction func tapExchangeButton(_ sender: UIButton) {
        guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
            return
        }
        let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
        inputAmountVC.partnerId = partnerInfo.id
        inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo!
        self.push(viewController: inputAmountVC)
    }
    
    @IBAction func tapTranferutton(_ sender: UIButton) {
        let transferFanTokenViewController = TransferFanTokenViewController()
        transferFanTokenViewController.transferType = .transferFantoken
        transferFanTokenViewController.fanTokenBalance = self.fanTokenBalance
        self.push(viewController: transferFanTokenViewController)
    }
    
    @IBAction func tapInformationButton(_ sender: UIButton) {
        let homeTeamInforVC = HomeTeamInfoViewController()
        homeTeamInforVC.view.backgroundColor = .color000000Alpha70
        homeTeamInforVC.modalPresentationStyle = .overFullScreen
        homeTeamInforVC.modalTransitionStyle = .crossDissolve
        self.present(viewController: homeTeamInforVC)
    }
    
    @IBAction func tapMenuAction(_ sender: UIButton) {
        self.segmentButtonGroup.forEach({
            if $0 == sender {
                $0.tintColor = self.themeInfo.textColor
                $0.titleLabel?.font = .font(with: .bold700, size: 14)
                if let index = self.segmentButtonGroup.firstIndex( of: $0) {
                    self.changeSegment(to: index)
                    self.setChangeUIButtonWhenChangeSegment(tag: index)
                }
            } else {
                $0.titleLabel?.font = .font(with: .medium500, size: 14)
                $0.tintColor = self.themeInfo.unselectedTabColor
            }
        })
    }
    
    @objc func authenticateError(_ notification: NSNotification) {
        CommonManager.clearData()
        DelegateManager.shared.setRootViewController(TabBarViewController(type: .landingPage))
    }
    
    @objc func backHomePage(_ notification: NSNotification) {
        CommonManager.clearData()
        DelegateManager.shared.setRootViewController(TabBarViewController(type: .landingPage))
    }
    
    @objc func login(_ notification: NSNotification) {
        CommonManager.clearData()
        self.push(viewController: LoginViewController(), animated: false)
    }
    
    @objc func universalLink(_ notification: NSNotification) {
        self.setupUniversalLink()
    }
}
