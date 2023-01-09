//
//  PayViewController.swift
//  Canow
//
//  Created by NhanTT13 on 12/22/21.
//

import UIKit

class PayViewController: BaseViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: "\(StringConstants.s06TitlePay.localized) \(self.merchant?.name ?? "")")
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet weak var stackViewTab: UIStackView!
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var useCouponTabButton: UIButton! {
        didSet {
            self.useCouponTabButton.setTitle(StringConstants.s06UseCoupon.localized, for: .normal)
            self.useCouponTabButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.useCouponTabButton.tintColor = .colorBlack111111
        }
    }
    @IBOutlet weak var viewBorderCoupon: UIView! {
        didSet {
            self.viewBorderCoupon.backgroundColor = .colorBlack111111
        }
    }
    @IBOutlet weak var normalPayTabButton: UIButton! {
        didSet {
            self.normalPayTabButton.setTitle(StringConstants.s06NormalPay.localized, for: .normal)
            self.normalPayTabButton.titleLabel?.font = .font(with: .medium500, size: 14)
            self.normalPayTabButton.tintColor = .colorB8B8B8
        }
    }
    @IBOutlet weak var viewBorderNormal: UIView! {
        didSet {
            self.viewBorderNormal.backgroundColor = .colorBlack111111
            self.viewBorderNormal.isHidden = true
        }
    }
    
    // MARK: - Properties
    private lazy var couponUseVC: PayCouponUseViewController = {
        let couponUseVC = PayCouponUseViewController()
        couponUseVC.merchantId = self.merchant?.partnerId
        couponUseVC.onSegmentIndex = {
            self.changeSegment(to: 1)
            self.setUpViewTapPayWithout()
        }
        return couponUseVC
    }()
    private lazy var normalPayVC: InputAmountTransactionViewController = {
        let normalPayVC = InputAmountTransactionViewController(transactionType: .pay)
        normalPayVC.payType = .payWithoutCoupon
        return normalPayVC
    }()
    private var currentIndex = 0
    private var viewControllers = [UIViewController]()
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        return pageViewController
    }()
    private lazy var segmentButtonGroup: [UIButton] = {
        let segmentButtonGroup: [UIButton] = [self.useCouponTabButton, self.normalPayTabButton]
        return segmentButtonGroup
    }()
    
    private var merchant: QRPayByST?
        
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Method
    override func bindViewAndViewModel() {
        
    }

    init(model: QRPayByST) {
        self.merchant = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

// MARK: - Methods
extension PayViewController {
    
    private func setupUI() {
        self.setupPageController()
    }
    
    private func setupPageController() {
        self.viewControllers = [
            self.couponUseVC,
            self.normalPayVC
        ]
        
        if let firstViewController = self.getViewController(at: 0) {
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.stackViewTab.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.pageViewController.didMove(toParent: self)
    }
    
    private func getViewController(at index: Int) -> UIViewController? {
        if self.viewControllers.isEmpty || index >= self.viewControllers.count {
            return nil
        }
        return self.viewControllers[index]
    }
    
    private func updateTheme(_ themeInfo: ThemeInfo) {
        
    }
    
    func changeSegment(to index: Int) {
        self.pageViewController.setViewControllers([self.getViewController(at: index)!],
                                                   direction: self.currentIndex <= index ? .forward : .reverse,
                                                   animated: true)
        self.currentIndex = index
    }
    
    func setUpViewTapPayWithout() {
        self.normalPayTabButton.titleLabel?.font = .font(with: .bold700, size: 14)
        self.normalPayTabButton.tintColor = .colorBlack111111
        self.useCouponTabButton.titleLabel?.font = .font(with: .medium500, size: 14)
        self.useCouponTabButton.tintColor = .colorB8B8B8
        self.viewBorderNormal.isHidden = false
        self.viewBorderCoupon.isHidden = true
    }

}

// MARK: - Action
extension PayViewController {
    
    @IBAction func tabMenuAction(_ sender: UIButton) {
        self.segmentButtonGroup.forEach({
            if $0 == sender {
                $0.tintColor = .colorBlack111111
                $0.titleLabel?.font = .font(with: .bold700, size: 14)
                if let index = self.segmentButtonGroup.firstIndex( of: $0) {
                    self.changeSegment(to: index)
                    if index == 0 {
                        self.viewBorderNormal.isHidden = true
                        self.viewBorderCoupon.isHidden = false
                    } else {
                        self.viewBorderNormal.isHidden = false
                        self.viewBorderCoupon.isHidden = true
                    }
                }
            } else {
                $0.titleLabel?.font = .font(with: .medium500, size: 14)
                $0.tintColor = .colorB8B8B8
            }
        })
    }
}
