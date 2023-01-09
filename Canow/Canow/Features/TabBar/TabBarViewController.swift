//
//  TabBarViewController.swift
//  Canow
//
//  Created by hieplh2 on 29/12/2021.
//

import UIKit
import Localize

enum TabBarType {
    case home, landingPage
}

enum TabBarItem {
    
    case home(TabBarType)
    case fanToken, yell, myPage
    
    var title: String {
        switch self {
        case .home:
            return StringConstants.home.localized
        case .fanToken:
            return StringConstants.fanToken.localized
        case .yell:
            return StringConstants.yell.localized
        case .myPage:
            return StringConstants.myPage.localized
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "ic_tab_home")
        case .fanToken:
            return UIImage(named: "ic_tab_fan_token")
        case .yell:
            return UIImage(named: "ic_tab_yell")
        case .myPage:
            return UIImage(named: "ic_tab_my_page")
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .home(let type):
            return type == .home ? HomePageViewController() : HomeLandingPageViewController()
        case .fanToken:
            let favoriteTeamVC = FavoriteTeamViewController()
            favoriteTeamVC.checkSignUpOrMyPage = .fanToken
            return favoriteTeamVC
        case .yell:
            return YellViewController()
        case .myPage:
            return PersonalViewController()
        }
    }
    
}

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    private let tabBarHeight: CGFloat = 50
    private var customTabBar: CustomTabItem!
    private var type: TabBarType
    private var currentIndex = 0
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.dropShadow(offSet: CGSize(width: 1, height: -1))
        return backgroundView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotificationCenter()
        self.view.addSubview(self.backgroundView)
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.frame.size.height = self.tabBarHeight
        self.tabBar.frame.origin.y = view.frame.height - self.tabBarHeight
    }
    
    init(type: TabBarType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods
extension TabBarViewController {
    
    private func setupUI() {
        self.customTabBar?.removeFromSuperview()
        self.setupCustomTabMenu([.home(self.type), .fanToken, .yell, .myPage], completion: { [weak self] viewControllers in
            guard let self = self else { return }
            self.viewControllers = viewControllers
        })
        self.setupBackgroundView()
        
        self.selectedIndex = self.currentIndex
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(configLanguage),
                                               name: NSNotification.Name(localizeChangeNotification),
                                               object: nil)
    }
    
    private func setupBackgroundView() {
        self.backgroundView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.customTabBar)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCustomTabMenu(_ menuItems: [TabBarItem],
                                    completion: @escaping ([UIViewController]) -> Void) {
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        self.customTabBar = CustomTabItem(menuItems: menuItems, currentTab: self.currentIndex, frame: frame)
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab(_:)
        
        self.view.addSubview(self.customTabBar)
        
        self.customTabBar.snp.makeConstraints { (make) in
            make.leading.trailing.width.equalTo(self.tabBar)
            make.trailing.equalTo(self.tabBar.snp.trailing)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(self.tabBarHeight)
        }
        
        menuItems.forEach({
            controllers.append($0.viewController)
        })
        
        self.view.layoutIfNeeded()
        completion(controllers)
    }
    
    private func changeTab(_ tab: Int) {
        self.selectedIndex = tab
        self.currentIndex = tab
    }
    
}

// MARK: - Actions
extension TabBarViewController {
    
    @objc func configLanguage() {
        for item in self.view.subviews where item is CustomTabItem {
            item.removeFromSuperview()
        }
        
        for item in self.view.subviews where item is CustomTabItem {
            item.removeFromSuperview()
        }
        
        self.setupUI()
    }
    
}
