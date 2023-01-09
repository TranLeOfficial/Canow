//
//  NewsListViewController.swift
//  Canow
//
//  Created by PhuNT14 on 15/11/2021.
//

import UIKit

class NewsListViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.news.localized)
            self.headerView.onBack = {
                DataManager.shared.deleteCheckFantoken()
                self.pop()
            }
        }
    }
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var newsListTableView: UITableView! {
        didSet {
            self.newsListTableView.delegate = self
            self.newsListTableView.dataSource = self
            self.newsListTableView.registerReusedCell(cellNib: NewsListTableViewCell.self)
            self.newsListTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    @IBOutlet weak var noResultImage: UIImageView! {
        didSet {
            self.noResultImage.image = UIImage(named: "bg_empty_state")
        }
    }
    @IBOutlet weak var noItemImageView: UIImageView! {
        didSet {
            self.noItemImageView.isHidden = true
        }
    }
    @IBOutlet weak var noItemTitleLabel: UILabel! {
        didSet {
            self.noItemTitleLabel.text = StringConstants.s11MessageEmptyNew.localized
            self.noItemTitleLabel.font = .font(with: .medium500, size: 14)
            self.noItemTitleLabel.textColor = .color646464
            self.noItemTitleLabel.isHidden = true
        }
    }
    
    // MARK: - Properties
    private var viewModel = NewsListViewModel()
    
    // MARK: - Life Cycle
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
        // self.reloadData()
        getNewsListSuccess()
        getNewsListFailure()
    }
    
}

// MARK: - Methods
extension NewsListViewController {
    
    func setupUI() {
        self.viewModel.getNewsListWhenDontLogin()
    }
    
    func getNewsListSuccess() {
        self.viewModel.getNewsListSuccess = {
            self.newsListTableView.reloadData()
            if self.viewModel.news.isEmpty {
                self.newsListTableView.isHidden = true
                self.noItemImageView.isHidden = false
                self.noItemTitleLabel.isHidden = false
            } else {
                self.newsListTableView.isHidden = false
                self.noItemImageView.isHidden = true
                self.noItemTitleLabel.isHidden = true
            }
        }
        
    }
    
    func getNewsListFailure() {
        self.viewModel.getNewListFailure = { error in
            self.showAlert(title: "Error", message: error.debugDescription, actions: ("OK", {}))
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: NewsListTableViewCell.self)
        cell?.configure(data: self.viewModel.news[indexPath.row])
        cell?.dropShadow()
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelected = self.viewModel.news[indexPath.row]
        let view = NewsDetailViewController()
        view.newID = newSelected.id
        self.push(viewController: view)
    }
    
}
