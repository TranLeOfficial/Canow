//
//  HomeCrowdfundingViewController.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import UIKit

class HomeCrowdfundingViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var crowdfundingTableView: UITableView! {
        didSet {
            self.crowdfundingTableView.delegate = self
            self.crowdfundingTableView.dataSource = self
            self.crowdfundingTableView.registerReusedCell(cellNib: HomeCrowdfundingTableViewCell.self)
            self.crowdfundingTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    @IBOutlet private weak var notificationNoDataLabel: UILabel! {
        didSet {
            self.notificationNoDataLabel.text = StringConstants.s11MessageNoCrowdfunding.localized
            self.notificationNoDataLabel.font = .font(with: .medium500, size: 14)
            self.notificationNoDataLabel.textColor = .color646464
            self.notificationNoDataLabel.isHidden = true
        }
    }
    
    // MARK: - Properties
    private let viewModel = HomeCrowdfundingViewModel()
    private var teamId: Int?
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkCustomerInfor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if teamId != DataManager.shared.getCustomerInfo()?.teamId && KeychainManager.apiIdToken() != nil {
            CommonManager.showLoading()
            self.viewModel.crowdfundingData.removeAll()
            self.crowdfundingTableView.reloadData()
        }
        self.loadData()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
    override func updateTheme() {
        self.notificationNoDataLabel.textColor = self.themeInfo.textColor
    }
    
}

// MARK: - Methods
extension HomeCrowdfundingViewController {
    
    private func getCrowdfunding() {
        if DataManager.shared.isFanToken() == .home {
            guard let customerInfo = DataManager.shared.getCustomerInfo() else {
                return
            }
            self.teamId = customerInfo.teamId
            self.viewModel.getCrowdfunding(partnerId: customerInfo.teamId)
        } else {
            guard let merchantInfo = DataManager.shared.getMerchantInfo() else {
                return
            }
            self.teamId = merchantInfo.id
            self.viewModel.getCrowdfunding(partnerId: merchantInfo.id)
        }
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
            self.viewModel.crowdfundingData.isEmpty ? (self.notificationNoDataLabel.isHidden = false) : (self.notificationNoDataLabel.isHidden = true)
            self.crowdfundingTableView.reloadData()
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
    private func loadData() {
        self.view.backgroundColor = self.themeInfo.bgPattern1 != nil ? .clear : .white
        self.getCrowdfunding()
    }
    
    private func checkCustomerInfor() {
        let customerInfo = DataManager.shared.getCustomerInfo()
        if customerInfo == nil {
            self.viewModel.crowdfundingData.removeAll()
            self.crowdfundingTableView.reloadData()
        }
    }
    
}

// MARK: - Actions
extension HomeCrowdfundingViewController {

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeCrowdfundingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.crowdfundingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: HomeCrowdfundingTableViewCell.self, indexPath: indexPath)
        let data = self.viewModel.crowdfundingData[indexPath.row]
        cell?.configure(data: data)
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cfCampaignDetailVC = CFCampaignDetailViewController()
        cfCampaignDetailVC.id = self.viewModel.crowdfundingData[indexPath.row].id ?? 0
        self.push(viewController: cfCampaignDetailVC)
    }
    
}
