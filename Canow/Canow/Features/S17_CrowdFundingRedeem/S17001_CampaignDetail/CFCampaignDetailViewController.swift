//
//  CFCampaignDetailViewController.swift
//  Canow
//
//  Created by hieplh2 on 02/12/2021.
//
//  Screen ID: S17001

import UIKit
import WebKit

class CFCampaignDetailViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.campaignDetail)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentView.backgroundColor = .white
        }
    }
    
    @IBOutlet private weak var successView: UIView! {
        didSet {
            self.successView.backgroundColor = .colorYellowFFCC00
            self.successView.layer.cornerRadius = self.successView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var successIcon: UIImageView! {
        didSet {
            self.successIcon.layer.cornerRadius = self.successIcon.frame.height / 2
        }
    }
    
    @IBOutlet private weak var successLabel: UILabel! {
        didSet {
            self.successLabel.font = .font(with: .bold700, size: 12)
            self.successLabel.textColor = .colorBlack111111
            self.successLabel.text = StringConstants.s17LbSuccessFulFundraising.localized
        }
    }
    
    @IBOutlet private weak var closedView: UIView! {
        didSet {
            self.closedView.backgroundColor = .colorB8B8B8
            self.closedView.layer.cornerRadius = self.closedView.frame.height / 2
            self.closedView.isHidden = true
        }
    }
    
    @IBOutlet private weak var closedLabel: UILabel! {
        didSet {
            self.closedLabel.font = .font(with: .bold700, size: 12)
            self.closedLabel.textColor = .colorBlack111111
            self.closedLabel.text = StringConstants.s17LbClosed.localized
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.delegate = self
        }
    }
    
    @IBOutlet private weak var cfImageView: UIImageView! {
        didSet {
            self.cfImageView.layer.cornerRadius = 20
            self.cfImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet private weak var cfTokenLogoImageView: UIImageView! {
        didSet {
            self.cfTokenLogoImageView.layer.cornerRadius = self.cfTokenLogoImageView.frame.height / 2
        }
    }
    
    @IBOutlet private weak var cfTokenLogoImageView2: UIImageView! {
        didSet {
            self.cfTokenLogoImageView2.layer.cornerRadius = self.cfTokenLogoImageView2.frame.height / 2
        }
    }
    
    @IBOutlet private weak var targetAmountLabel: UILabel! {
        didSet {
            self.targetAmountLabel.font = .font(with: .black900, size: 20)
            self.targetAmountLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var targetLabel: UILabel! {
        didSet {
            self.targetLabel.font = .font(with: .medium500, size: 14)
            self.targetLabel.textColor = .colorB8B8B8
            self.targetLabel.text = StringConstants.s17LbTarget.localized
        }
    }
    
    @IBOutlet private weak var dueDateLabel: UILabel! {
        didSet {
            self.dueDateLabel.font = .font(with: .bold700, size: 14)
            self.dueDateLabel.textColor = .colorBlack111111
            self.dueDateLabel.text = StringConstants.s17LbDueDate.localized
        }
    }
    
    @IBOutlet private weak var dueDateTitleLabel: UILabel! {
        didSet {
            self.dueDateTitleLabel.font = .font(with: .medium500, size: 12)
            self.dueDateTitleLabel.textColor = .color646464
            self.dueDateTitleLabel.text = StringConstants.s17LbDueDate.localized
        }
    }
    
    @IBOutlet private weak var currentAmountLabel: UILabel! {
        didSet {
            self.currentAmountLabel.font = .font(with: .black900, size: 20)
            self.currentAmountLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var raisedLabel: UILabel! {
        didSet {
            self.raisedLabel.font = .font(with: .medium500, size: 14)
            self.raisedLabel.textColor = .colorB8B8B8
            self.raisedLabel.text = StringConstants.s17LbRaised.localized
        }
    }
    
    @IBOutlet private weak var progressView: ProgressView!
    
    @IBOutlet private weak var backerLabel: UILabel! {
        didSet {
            self.backerLabel.font = .font(with: .bold700, size: 14)
            self.backerLabel.textColor = .colorBlack111111
        }
    }
    
    @IBOutlet private weak var backerTitleLabel: UILabel! {
        didSet {
            self.backerTitleLabel.font = .font(with: .medium500, size: 12)
            self.backerTitleLabel.textColor = .color646464
            self.backerTitleLabel.text = StringConstants.s17LbBackers.localized
        }
    }
    
    @IBOutlet private weak var backerJPLanguageLabel: UILabel! {
        didSet {
            self.backerJPLanguageLabel.font = .font(with: .medium500, size: 12)
            self.backerJPLanguageLabel.textColor = .color646464
            self.backerJPLanguageLabel.text = StringConstants.s17LbBackers.localized
        }
    }
    
    @IBOutlet private weak var descriptionLabel: MoreLessLabel! {
        didSet {
            self.descriptionLabel.font = .font(with: .regular400, size: 14)
            self.descriptionLabel.textColor = .color646464
        }
    }
    
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl! {
        didSet {
            self.segmentedControl.setButtonTitles(buttonTitles: [StringConstants.s17TitleCouponRewards.localized, StringConstants.s17TitleInfomation.localized])
            self.segmentedControl.selectorViewColor = .black
            self.segmentedControl.selectorTextColor = .black
            self.segmentedControl.delegate = self
        }
    }
    
    @IBOutlet private weak var couponTableView: UITableView! {
        didSet {
            self.couponTableView.delegate = self
            self.couponTableView.dataSource = self
            self.couponTableView.registerReusedCell(cellNib: CouponCell.self)
            self.couponTableView.separatorStyle = .none
        }
    }
    
    @IBOutlet private weak var heightCouponTabelView: NSLayoutConstraint!
    
    @IBOutlet private weak var contentLabel: UILabel! {
        didSet {
            self.contentLabel.font = .font(with: .regular400, size: 14)
            self.contentLabel.textColor = .color646464
        }
    }
    @IBOutlet private weak var couponView: UIView!
    @IBOutlet weak var webViewInfomation: WKWebView! {
        didSet {
            self.webViewInfomation.scrollView.showsVerticalScrollIndicator = false
            self.webViewInfomation.scrollView.showsHorizontalScrollIndicator = false
            self.webViewInfomation.navigationDelegate = self
            self.webViewInfomation.scrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var webViewHeightContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let viewModel = CFCampaignDetailViewModel()
    private var lastContentOffset: CGFloat = 0
    private let heighCell: CGFloat = 284
    private var fantoken: String = ""
    private var couponId: String = ""
    var id = 0
    var observing = false
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.getCrowdFundingDetailSuccess()
        
        self.fetchDataSuccess()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension CFCampaignDetailViewController {
    
    private func setupUI() {
        self.view.backgroundColor  = .colorYellowFFCC00
        self.fetchData()
    }
    
    private func fetchData() {
        CommonManager.showLoading()
        self.viewModel.getCrowdFundingDetail(id: self.id)
    }
    
    private func getCrowdFundingDetailSuccess() {
        self.viewModel.getCrowdFundingDetailSuccess = { cfDetail in
            CommonManager.hideLoading()
            self.cfImageView.kf.setImage(with: CommonManager.getImageURL(cfDetail.image))
            if cfDetail.status == .closed {
                self.closedView.isHidden = false
                self.segmentedControl.setButtonTitles(buttonTitles: [StringConstants.s17TitleInfomation.localized])
                self.segmentedControl.isUserInteractionEnabled = false
                self.contentLabel.isHidden = true
                self.webViewInfomation.isHidden = false
                self.couponView.isHidden = true
                self.segmentedControl.selectorViewColor = .white
            }
            self.cfTokenLogoImageView.kf.setImage(with: CommonManager.getImageURL(cfDetail.fantokenLogo))
            self.cfTokenLogoImageView2.kf.setImage(with: CommonManager.getImageURL(cfDetail.fantokenLogo))
            self.cfImageView.isHidden = false
            self.fantoken = cfDetail.fantokenLogo
            self.headerView.setTitle(title: cfDetail.name)
            self.descriptionLabel.numOfLines = 3
            self.descriptionLabel.fullText = cfDetail.description.htmlToString.replacingOccurrences(of: "\n", with: "")
            self.targetAmountLabel.text = cfDetail.targetAmount.formatPrice()
            self.dueDateLabel.text = cfDetail.availableTo.formatDateString(DateFormat.DATE_CURRENT, DateFormat.DATE_FORMAT_CROWDFUNDING)
            self.currentAmountLabel.text = "\(cfDetail.currentReceivedAmount)".formatPrice()
            if let target = Double(cfDetail.targetAmount) {
                let current = Double(cfDetail.currentReceivedAmount)
                self.progressView.current = current
                self.progressView.total = target
                self.successView.isHidden = current / target < 1
            }
            self.progressView.isHidden = false
            self.backerLabel.text = "\(cfDetail.totalBacker)".formatPrice()
            self.backerJPLanguageLabel.isHidden = !CommonManager.checkLanguageJP
            self.backerTitleLabel.isHidden = CommonManager.checkLanguageJP
            self.contentLabel.text = cfDetail.content.htmlToString
            let fontSize = 40
            let fontSetting = "<span style=\"font-size: \(fontSize);word-wrap: break-word\"</span>"
            self.webViewInfomation.loadHTMLString(fontSetting + cfDetail.content, baseURL: nil)
            self.viewModel.getCourseList(id: self.id)
        }
    }
    
    private func fetchDataSuccess() {
        self.viewModel.getCourseListSuccess = {
            self.heightCouponTabelView.constant = CGFloat(self.viewModel.courseList?.count ?? 0) * self.heighCell
            self.couponTableView.isScrollEnabled = self.viewModel.courseList?.count ?? 0 > 1
            self.couponTableView.reloadData()
        }
        
        self.viewModel.getCourseDetailSuccess = { courseDetail in
            let transactionConfirm = TransactionConfirmViewController(transactionType: .redeemCourse)
            transactionConfirm.fanTokenLogo = self.fantoken
            transactionConfirm.course = courseDetail
            self.push(viewController: transactionConfirm)
        }
        
        self.viewModel.checkRedeemCourseSuccess = {
            self.viewModel.getCourseDetail(couponId: self.couponId)
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if error == StringConstants.ERROR_CODE_401 || error == StringConstants.ERROR_CODE_403 {
                CommonManager.showLogin()
                return
            }
            switch error {
            case MessageCode.E032.message:
                self.showPopup(title: StringConstants.s17TitleCouponNotAvailable.localized,
                               message: StringConstants.s14RedeemCouponError.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.setupUI()
                }))
            case MessageCode.E033.message:
                self.showPopup(title: StringConstants.s14TitleSoldOutCrowdfunding.localized,
                               message: StringConstants.s14MessageSoldOutCrowdfunding.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.setupUI()
                }))
            case MessageCode.E017.message:
                self.showPopup(title: StringConstants.s14MessageNotEnoughBalance.localized,
                               message: StringConstants.s14Message_ExchangeMore.localized,
                               popupBg: UIImage(named: "bg_yourBalance"),
                               leftButton: (StringConstants.s01BtnCancel.localized, {}),
                               rightButton: (StringConstants.s17BtnExchange.localized, {
                    guard let partnerInfo = DataManager.shared.getMerchantInfo() else {
                        return
                    }
                    let inputAmountVC = InputAmountTransactionViewController(transactionType: .exchange)
                    inputAmountVC.partnerId = partnerInfo.id
                    inputAmountVC.urlImageLogoFantoken = partnerInfo.fantokenLogo!
                    self.push(viewController: inputAmountVC)
                }))
            case MessageCode.E065.message:
                self.showPopup(title: MessageCode.E065.message,
                               message: StringConstants.s17MessageCheckAgain.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.pop()
                }))
            case MessageCode.E067.message:
                self.showPopup(title: MessageCode.E067.message,
                               message: StringConstants.s14RedeemOtherCoupons.localized,
                               popupBg: UIImage(named: "bg_failed_tiny"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                }))
            default:
                self.showAlert(title: "Error", message: error)
            }
        }
    }
    
}

// MARK: - Actions
extension CFCampaignDetailViewController {
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CFCampaignDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.courseList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heighCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: CouponCell.self)
        cell?.configure(data: self.viewModel.courseList?[indexPath.row])
        cell?.donateRedeem = { couponId in
            if !CommonManager.checkLandingPage() {
                return
            }
            self.couponId = couponId
            self.viewModel.checkRedeemCourse(couponId: couponId)
        }
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = self.viewModel.courseList?[indexPath.row]
        let couponDetailVC = CouponDetailViewController()
        couponDetailVC.couponId = course?.couponId ?? ""
        couponDetailVC.fantoken = course?.fantokenLogo ?? ""
        self.push(viewController: couponDetailVC)
    }
    
}

// MARK: - CustomSegmentedControlDelegate
extension CFCampaignDetailViewController: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        switch self.viewModel.crowdFundingDetail?.status {
        case .inProgress:
            self.couponView.isHidden = index != 0
            self.webViewInfomation.isHidden = index != 1
        default:
            break
        }
    }
    
    // Height webview
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        self.webViewInfomation.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            if context == &MyObservationContext {
                webViewHeightContraint.constant = self.webViewInfomation.scrollView.contentSize.height
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func stopObservingHeight() {
        self.webViewInfomation.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
}

// MARK: - WebView
extension CFCampaignDetailViewController: WKNavigationDelegate, UIWebViewDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard case .linkActivated = navigationAction.navigationType,
              let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        if url.absoluteString.contains(Constants.DEEP_LINK_URL) {
            let userActivity =  NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
            userActivity.webpageURL = url
            let checkuserActivity = UIApplication.shared.delegate?.application?(UIApplication.shared, continue: userActivity, restorationHandler: { _ in }) ?? false
            if !checkuserActivity {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewHeightContraint.constant = webViewInfomation.scrollView.contentSize.height
        if (!observing) {
            self.startObservingHeight()
        }
    }
}
