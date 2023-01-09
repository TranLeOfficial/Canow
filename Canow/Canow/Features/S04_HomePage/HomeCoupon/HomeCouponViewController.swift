//
//  HomeCouponViewController.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import UIKit

class HomeCouponViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var menuActionView: UIView! {
        didSet {
            self.menuActionView.clipsToBounds = true
            self.menuActionView.backgroundColor = .colorF4F4F4
            self.menuActionView.layer.borderWidth = 1
            self.menuActionView.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.menuActionView.layer.cornerRadius = 22.5
        }
    }
    @IBOutlet private weak var purchasedButton: UIButton! {
        didSet {
            self.purchasedButton.setTitle(StringConstants.s11LbPurchased.localized, for: .normal)
            self.purchasedButton.setTitle(StringConstants.s11LbPurchased.localized, for: .highlighted)
            self.purchasedButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.purchasedButton.tintColor = .colorB8B8B8
            self.purchasedButton.layer.cornerRadius = 22.5
        }
    }
    @IBOutlet private weak var notPurchasedButton: UIButton! {
        didSet {
            self.notPurchasedButton.setTitle(StringConstants.s11LbNotPurchased.localized, for: .normal)
            self.notPurchasedButton.setTitle(StringConstants.s11LbNotPurchased.localized, for: .highlighted)
            self.notPurchasedButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.notPurchasedButton.tintColor = .colorBlack111111
            self.notPurchasedButton.layer.borderWidth = 1
            self.notPurchasedButton.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.notPurchasedButton.backgroundColor = .white
            self.notPurchasedButton.layer.cornerRadius = 22.5
        }
    }
  
    // MARK: - Properties
    private let viewModel = HomeCouponViewModel()
    private var currentIndex = 0
    private var viewControllers = [UIViewController]()
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        return pageViewController
    }()
    private lazy var purchasedVC: PurchasedViewController = {
        let purchasedVC = PurchasedViewController()
        return purchasedVC
    }()
    private lazy var notPurchasedVC: NotPurchasedViewController = {
        let notPurchasedVC = NotPurchasedViewController()
        return notPurchasedVC
    }()
    private lazy var segmentButtonGroup: [UIButton] = {
        let segmentButtonGroup: [UIButton] = [self.notPurchasedButton, self.purchasedButton]
        return segmentButtonGroup
    }()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageController()
        self.setupRedEnvelope()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = self.themeInfo.bgPattern1 != nil ? .clear : .white
    }

}

// MARK: - Methods
extension HomeCouponViewController {
    
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
            self.notPurchasedVC,
            self.purchasedVC
        ]
        
        if let firstViewController = self.getViewController(at: 0) {
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(self.menuActionView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.pageViewController.didMove(toParent: self)
    }
    
    private func setupRedEnvelope() {
        switch DataManager.shared.isFanToken() {
        case.redEnvelope:
            self.purchasedButton.tintColor = .colorBlack111111
            self.purchasedButton.titleLabel?.font = .font(with: .bold700, size: 14)
            self.changeSegment(to: 1)
            self.setChangeUIButtonWhenChangeSegment(tag: 1)
            self.notPurchasedButton.titleLabel?.font = .font(with: .medium500, size: 14)
            self.notPurchasedButton.tintColor = .colorB8B8B8
        default:
            break
        }
        
    }
    
    private func setChangeUIButtonWhenChangeSegment(tag index: Int) {
        switch index {
        case 0:
            self.notPurchasedButton.tintColor = .colorBlack111111
            self.notPurchasedButton.backgroundColor = .white
            self.notPurchasedButton.configBorder(borderWidth: 1,
                                              borderColor: .colorE5E5E5,
                                              cornerRadius: 22.5)
            
            self.purchasedButton.layer.borderWidth = 0
            self.purchasedButton.backgroundColor = .clear
            self.purchasedButton.tintColor = .colorB8B8B8
        case 1:
            self.purchasedButton.tintColor = .colorBlack111111
            self.purchasedButton.backgroundColor = .white
            self.purchasedButton.configBorder(borderWidth: 1,
                                              borderColor: .colorE5E5E5,
                                              cornerRadius: 22.5)
            
            self.notPurchasedButton.layer.borderWidth = 0
            self.notPurchasedButton.backgroundColor = .clear
            self.notPurchasedButton.tintColor = .colorB8B8B8
        default:
            break
        }
    }
    
}

// MARK: - Actions
extension HomeCouponViewController {
    @IBAction func tapMenuAction(_ sender: UIButton) {
        self.segmentButtonGroup.forEach({
            if $0 == sender {
                $0.tintColor = .colorBlack111111
                $0.titleLabel?.font = .font(with: .bold700, size: 14)
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
