//
//  TeamLandingPageViewController.swift
//  Canow
//
//  Created by TuanBM6 on 2/7/22.
//

import UIKit
import Kingfisher

class TeamLandingPageViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.backButtonHidden = false
            self.headerView.rightButtonHidden = false
            self.headerView.rightButtonImage = UIImage(named: "ic_information_team")
            self.headerView.onPressRightButton = {
                let homeTeamInforVC = HomeTeamInfoViewController()
                homeTeamInforVC.view.backgroundColor = .color000000Alpha70
                homeTeamInforVC.modalPresentationStyle = .overFullScreen
                homeTeamInforVC.modalTransitionStyle = .crossDissolve
                self.present(viewController: homeTeamInforVC)
            }
            self.headerView.onBack = {
                DataManager.shared.saveCheck(check: .home)
                self.pop()
            }
        }
    }
    @IBOutlet private weak var logoImageView: UIImageView! {
        didSet {
            self.logoImageView.layer.cornerRadius = self.logoImageView.frame.height / 2
        }
    }
    @IBOutlet private weak var couponButton: UIButton! {
        didSet {
            self.couponButton.setTitle(StringConstants.s11LbCoupon.localized, for: .normal)
            self.couponButton.setTitle(StringConstants.s11LbCoupon.localized, for: .highlighted)
            self.couponButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.couponButton.tintColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var crowdFundingButton: UIButton! {
        didSet {
            self.crowdFundingButton.setTitle(StringConstants.s11LbCrowdfunding.localized, for: .normal)
            self.crowdFundingButton.setTitle(StringConstants.s11LbCrowdfunding.localized, for: .highlighted)
            self.crowdFundingButton.titleLabel?.font = .font(with: .medium500, size: 14)
            self.crowdFundingButton.tintColor = .colorB8B8B8
            self.crowdFundingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet private weak var remittanceButton: UIButton! {
        didSet {
            self.remittanceButton.setTitle(StringConstants.s11LbRemittance.localized, for: .normal)
            self.remittanceButton.setTitle(StringConstants.s11LbRemittance.localized, for: .highlighted)
            self.remittanceButton.titleLabel?.font = .font(with: .medium500, size: 14)
            self.remittanceButton.tintColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var contentItemsView: UIView! {
        didSet {
            self.contentItemsView.layer.cornerRadius = 20
            self.contentItemsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentItemsView.backgroundColor = .white
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
    @IBOutlet private weak var menuActionStackView: UIStackView!
    private var currentIndex = 0
    private var viewControllers = [UIViewController]()
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        return pageViewController
    }()
    private lazy var couponLandingPageVC: CouponLandingPageViewController = {
        let couponLandingPageVC = CouponLandingPageViewController()
        return couponLandingPageVC
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
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageController()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
//        self.reloadData()
//        self.fetchDataFailure()
    }

}

// MARK: - Methods
extension TeamLandingPageViewController {
    
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
            self.couponLandingPageVC,
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
        
        if let teamInfo = DataManager.shared.getMerchantInfo() {
            self.headerView.setTitle(title: teamInfo.name)
            self.logoImageView.kf.setImage(with: CommonManager.getImageURL(teamInfo.logo))
        }
    }
    
    private func setChangeUIButtonWhenChangeSegment(tag index: Int) {
        for view in self.segmentViewGroup {
            view.isHidden = view.tag != index
        }
    }
    
}

// MARK: - Actions
extension TeamLandingPageViewController {
    
    @IBAction func tapMenuAction(_ sender: UIButton) {
        self.segmentButtonGroup.forEach({
            if $0 == sender {
                $0.titleLabel?.font = .font(with: .bold700, size: 14)
                $0.tintColor = .colorBlack111111
                if let index = self.segmentButtonGroup.firstIndex( of: $0) {
                    self.changeSegment(to: index)
                    self.setChangeUIButtonWhenChangeSegment(tag: index)
                }
            } else {
                $0.titleLabel?.font = .font(with: .medium500, size: 14)
                $0.tintColor = .colorB8B8B8
            }
        })
    }
    
}
