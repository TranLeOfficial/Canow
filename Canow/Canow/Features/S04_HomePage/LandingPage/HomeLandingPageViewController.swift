//
//  HomeLandingPageViewController.swift
//  Canow
//
//  Created by hieplh2 on 07/02/2022.
//

import UIKit

class HomeLandingPageViewController: BaseViewController {
    // MARK: - Outlet
    @IBOutlet weak var loginButton: CustomButton! {
        didSet {
            self.loginButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.loginButton.layer.cornerRadius = 7
            self.loginButton.setTitle(StringConstants.s03BtnLogin.localized, for: .normal)
            self.loginButton.setTitle(StringConstants.s03BtnLogin.localized , for: .highlighted)
            self.loginButton.isEnabled = true
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.clipsToBounds = true
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.contentView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var noItemView: UIView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var newsLabel: UILabel! {
        didSet {
            self.newsLabel.font = .font(with: .bold700, size: 16)
            self.newsLabel.textColor = .colorBlack111111
            self.newsLabel.text = StringConstants.news.localized
        }
    }
    @IBOutlet weak var viewMoreLabel: UILabel! {
        didSet {
            self.viewMoreLabel.font = .font(with: .light300, size: 14)
            self.viewMoreLabel.textColor = .color646464
            self.viewMoreLabel.text = StringConstants.viewMore.localized
            self.viewMoreLabel.isEnabled = true
        }
    }
    
    @IBOutlet weak var noItemLabel: UILabel! {
        didSet {
            self.noItemLabel.text = StringConstants.theNewest.localized
            self.noItemLabel.font = .font(with: .medium500, size: 14)
            self.noItemLabel.textColor = UIColor.color646464
        }
    }
    @IBOutlet weak var myTableView: UITableView! {
        didSet {
            self.myTableView.registerReusedCell(cellNib: HomeLandingPageCell.self)
            self.myTableView.delegate = self
            self.myTableView.dataSource = self
        }
    }
    @IBOutlet weak var viewMoreButton: UIButton! {
        didSet {
            self.viewMoreButton.setTitle(StringConstants.viewMore.localized, for: .normal)
            self.viewMoreButton.setTitle(StringConstants.viewMore.localized, for: .highlighted)
            self.viewMoreButton.titleLabel?.font = .font(with: .light300, size: 14)
        }
    }
    @IBOutlet weak var newsNoItemLabel: UILabel! {
        didSet {
            self.newsNoItemLabel.font = .font(with: .bold700, size: 16)
            self.newsNoItemLabel.textColor = .colorBlack111111
            self.newsNoItemLabel.text = StringConstants.news.localized
        }
    }
    
    // MARK: - Properties
    let viewModel = HomeLandingPageViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        getNewsListSuccess()
        getNewsListFailure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.backHomePage),
                                               name: NSNotification.backHomePage,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.login),
                                               name: NSNotification.Login,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.backHomePage, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Login, object: nil)
    }
    
}

// MARK: - Methods
extension HomeLandingPageViewController {
    func setupUI() {
        self.viewModel.getNewsListWhenDontLogin()
    }
    
    func getNewsListSuccess() {
        self.viewModel.getNewsListSuccess = {
            self.myTableView.reloadData()
            if self.viewModel.news.isEmpty {
                self.newsView.isHidden = true
                self.noItemView.isHidden = false
            } else {
                self.newsView.isHidden = false
                self.noItemView.isHidden = true
            }
        }
        self.viewModel.getStableTokenDefault()
    }
    
    func getNewsListFailure() {
        self.viewModel.getNewListFailure = { error in
            self.showAlert(title: "Error", message: error.debugDescription, actions: ("OK", {}))
        }
    }
    
}

// MARK: - Action
extension HomeLandingPageViewController {
    @IBAction func loginButtonAction(_ sender: CustomButton) {
        self.push(viewController: LoginViewController())
    }
    @IBAction func viewMoreButtonAction(_ sender: UIButton) {
        let newListVC = NewsListViewController()
        self.push(viewController: newListVC)
    }
}

// MARK: - TableView
extension HomeLandingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: HomeLandingPageCell.self)
        cell?.configure(data: self.viewModel.news[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelected = self.viewModel.news[indexPath.row]
        let view = NewsDetailViewController()
        view.newID = newSelected.id
        self.push(viewController: view)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

}

extension HomeLandingPageViewController {
    
    @objc func backHomePage(_ notification: NSNotification) {
        CommonManager.clearData()
        DelegateManager.shared.setRootViewController(TabBarViewController(type: .landingPage))
    }
    
    @objc func login(_ notification: NSNotification) {
        self.push(viewController: LoginViewController(), animated: false)
    }
    
}
