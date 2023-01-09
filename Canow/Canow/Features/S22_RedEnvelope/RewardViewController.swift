//
//  RewardViewController.swift
//  Canow
//
//  Created by TuanBM6 on 24/02/2022.
//

import UIKit
import Kingfisher

class RewardViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var rewardImageView: UIImageView! {
        didSet {
            self.rewardImageView.layer.cornerRadius = 6
            self.rewardImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.font = .font(with: .bold700, size: 18)
            self.titleLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var subtitleLabel: UILabel! {
        didSet {
            self.subtitleLabel.font = .font(with: .regular400, size: 14)
            self.subtitleLabel.textColor = .color646464
        }
    }
    @IBOutlet private weak var stableTokenImageView: UIImageView!
    @IBOutlet private weak var rewardLabel: UILabel! {
        didSet {
            self.rewardLabel.font = .font(with: .medium500, size: 14)
            self.rewardLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var seeGiftButton: CustomButton! {
        didSet {
            self.seeGiftButton.backgroundColor = .colorE5E5E5
            self.seeGiftButton.isUserInteractionEnabled = false
//            self.seeGiftButton.setupUI()
        }
    }
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var stableTokenView: UIView!
    @IBOutlet private weak var animationImageView: UIImageView! {
        didSet {
            self.animationImageView.loadGif(name: "animation")
        }
    }
    
    // MARK: - Properties
    var idEvent: Int = 0
    private let viewModel =  RewardViewModel()
    private var timeRemaining: Int = 10
    private var timer: Timer!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.fetchDataSuccess()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension RewardViewController {
    
    private func setupUI() {
        self.viewModel.getPartnerInfomationSelected(id: idEvent)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        self.setupDisconnectNetwork()
    }
    
    private func setupDisconnectNetwork() {
        ConnectionManager.shared.disconnectInternet = {
            if self.viewModel.transactionStatus == nil {
                self.timer.invalidate()
                self.recallTransaction()
            }
        }
    }
    
    private func recallTransaction() {
        if !ConnectionManager.shared.isConnect {
            self.showPopup(title: StringConstants.s22MessageDisconnectInternet.localized,
                           popupBg: UIImage(named: "ic_disconnect_internet"),
                           leftButton: (StringConstants.s01BtnBack.localized, {
                self.dismiss(animated: true)
                self.popToRoot() }),
                           rightButton: (StringConstants.s04BtnTryAgain.localized, {
                self.dismiss(animated: true)
                self.recallTransaction()
            }))
            return
        }
        timeRemaining = 10
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
        CommonManager.showLoading()
        self.viewModel.getPartnerInfomationSelected(id: idEvent)
    }
    
    private func fetchDataSuccess() {
        self.viewModel.fetchDataSuccess = {
            self.titleLabel.text = self.viewModel.redEnvelopeCustomerScanDetail?.messageContent1
            self.subtitleLabel.text = self.viewModel.redEnvelopeCustomerScanDetail?.messageContent2
            self.rewardImageView.kf.setImage(with: CommonManager.getImageURL(self.viewModel.redEnvelopeCustomerScanDetail?.messageImage))
            switch self.viewModel.redEnvelopeCustomerScanDetail?.rewardType {
            case .coupon:
                self.rewardLabel.text = self.viewModel.redEnvelopeCustomerScanDetail?.couponName
                self.seeGiftButton.setTitle(StringConstants.s22BtnSeeYourGift.localized, for: .normal)
                self.seeGiftButton.setTitle(StringConstants.s22BtnSeeYourGift.localized, for: .highlighted)
            case .stableToken:
                self.rewardLabel.font = .font(with: .bold700, size: 24)
                self.rewardLabel.numberOfLines = 1
                self.rewardLabel.text = "\(self.viewModel.redEnvelopeCustomerScanDetail?.amount ?? 0)".formatPrice()
                self.stableTokenImageView.kf.setImage(with: CommonManager.getImageURL(self.viewModel.redEnvelopeCustomerScanDetail?.tokenLogo))
                self.seeGiftButton.setTitle(StringConstants.s22BtnHome.localized, for: .normal)
                self.seeGiftButton.setTitle(StringConstants.s22BtnHome.localized, for: .highlighted)
                self.stableTokenView.isHidden = false
            default:
                return
            }
            self.viewModel.getTransactionStatus(transactionId: self.viewModel.redEnvelopeCustomerScanDetail?.transactionId ?? "")
        }
        self.viewModel.fetchTransactionStatusSuccess = {
            switch self.viewModel.transactionStatus?.status {
            case .completed:
                CommonManager.hideLoading()
                self.contentView.isHidden = false
                self.timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.seeGiftButton.setupUI()
                    self.seeGiftButton.isUserInteractionEnabled = true
                    self.animationImageView.image = nil
                }
                self.animationImageView.isHidden = false
            case .pending:
                self.viewModel.getTransactionStatus(transactionId: self.viewModel.redEnvelopeCustomerScanDetail?.transactionId ?? "")
            case .failed:
                self.timer.invalidate()
                self.recallTransaction()
            default:
                self.timer.invalidate()
            }
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            self.timer.invalidate()
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
            if error == MessageCode.E500.message {
                self.showPopup(title: StringConstants.s22MessageDisconnectInternet.localized,
                               popupBg: UIImage(named: "ic_disconnect_internet"),
                               leftButton: (StringConstants.s01BtnBack.localized, {
                    self.dismiss(animated: true)
                    self.popToRoot()
                    NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                }),
                               rightButton: (StringConstants.s04BtnTryAgain.localized, {
                    self.dismiss(animated: true)
                    self.recallTransaction()
                }))
                return
            }
            switch error {
            case MessageCode.E072.message, MessageCode.E078.message:
                self.showPopup(title: MessageCode.E072.message,
                               popupBg: UIImage(named: "bg_failed_transaction"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.popToRoot()
                     }))
            case MessageCode.E075.message:
                self.showPopup(title: MessageCode.E075.message,
                               popupBg: UIImage(named: "bg_event_closed"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.popToRoot()
                     }))
            case MessageCode.E076.message:
                self.showPopup(title: StringConstants.s22MessageLimitedGift.localized,
                               popupBg: UIImage(named: "bg_invalid_gift"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.popToRoot()
                     }))
            case MessageCode.E077.message:
                self.showPopup(title: MessageCode.E077.message,
                               message: StringConstants.s22MessageReceivedGift.localized,
                               popupBg: UIImage(named: "bg_invalid_gift"),
                               rightButton: (StringConstants.s04BtnOk.localized, {
                    self.dismiss(animated: true, completion: nil)
                    self.popToRoot()
                     }))
            default:
                break
            }
            NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
        }
    }
    
}

// MARK: - Actions
extension RewardViewController {
    
    @IBAction private func seeGiftAction(_ sender: Any) {
        switch self.viewModel.redEnvelopeCustomerScanDetail?.rewardType {
        case .coupon:
            guard let eCouponId = self.viewModel.redEnvelopeCustomerScanDetail?.eCouponId else { return }
            let viewController = CouponViewController(type: .redEnvelope, eCouponId: eCouponId)
            self.push(viewController: viewController)
        case .stableToken:
            self.popToRoot()
            NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
        default:
            self.popToRoot()
        }
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            if self.viewModel.redEnvelopeCustomerScanDetail == nil || self.viewModel.transactionStatus == nil {
                self.showPopup(title: StringConstants.s22MessageDisconnectInternet.localized,
                               popupBg: UIImage(named: "ic_disconnect_internet"),
                               leftButton: (StringConstants.s01BtnBack.localized, {
                    self.dismiss(animated: true)
                    self.popToRoot()
                    NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
                }),
                               rightButton: (StringConstants.s04BtnTryAgain.localized, {
                    self.dismiss(animated: true)
                    self.recallTransaction()
                }))
                return
            }
            self.showPopup(title: StringConstants.s22MessageProcess.localized,
                           popupBg: UIImage(named: "ic_reward_long_time"),
                           leftButton: (StringConstants.s22Home.localized, {
                CommonManager.hideLoading()
                self.dismiss(animated: true)
                self.popToRoot()
                NotificationCenter.default.post(name: NSNotification.tabBarChanged, object: 0)
            }),
                           rightButton: (StringConstants.s22BtnCheck.localized, {
                let viewController = HistoryDetailViewController()
                viewController.transactionId = self.viewModel.redEnvelopeCustomerScanDetail?.transactionId ?? ""
                self.push(viewController: viewController)
            }))
        }
    }
    
}
