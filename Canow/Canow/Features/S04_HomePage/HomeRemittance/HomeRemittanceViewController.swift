//
//  HomeRemittanceViewController.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import UIKit

class HomeRemittanceViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var remittanceTableView: UITableView! {
        didSet {
            self.remittanceTableView.delegate = self
            self.remittanceTableView.dataSource = self
            self.remittanceTableView.registerReusedCell(cellNib: HomeRemittanceTableViewCell.self)
            self.remittanceTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    @IBOutlet private weak var notificationNoDataLabel: UILabel! {
        didSet {
            self.notificationNoDataLabel.text = StringConstants.s11MessageNoRemittance.localized
            self.notificationNoDataLabel.font = .font(with: .medium500, size: 14)
            self.notificationNoDataLabel.textColor = .color646464
            self.notificationNoDataLabel.isHidden = true
        }
    }
    
    // MARK: - Properties
    private let viewModel = HomeRemittanceViewModel()
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
            self.viewModel.remittanceData.removeAll()
            self.remittanceTableView.reloadData()
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
extension HomeRemittanceViewController {
    
    private func getRemittance() {
        if DataManager.shared.isFanToken() == .home {
            guard let customerInfo = DataManager.shared.getCustomerInfo() else {
                return
            }
            self.teamId = customerInfo.teamId
            self.viewModel.getRemittance(partnerId: customerInfo.teamId)
        } else {
            guard let merchantInfo = DataManager.shared.getMerchantInfo() else {
                return
            }
            self.teamId = merchantInfo.id
            self.viewModel.getRemittance(partnerId: merchantInfo.id)
        }
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
            self.viewModel.remittanceData.isEmpty ? (self.notificationNoDataLabel.isHidden = false) : (self.notificationNoDataLabel.isHidden = true)
            self.remittanceTableView.reloadData()
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
        self.getRemittance()
    }
    
    private func checkCustomerInfor() {
        let customerInfo = DataManager.shared.getCustomerInfo()
        if customerInfo == nil {
            self.viewModel.remittanceData.removeAll()
            self.remittanceTableView.reloadData()
        }
    }
}

// MARK: - Actions
extension HomeRemittanceViewController {
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeRemittanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.remittanceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: HomeRemittanceTableViewCell.self, indexPath: indexPath)
        let data = self.viewModel.remittanceData[indexPath.row]
        cell?.configure(data: data)
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let remittance = self.viewModel.remittanceData[indexPath.row]
        let viewController = RemittanceCampaignViewController()
        viewController.partnerId = teamId ?? 0
        viewController.remittanceId = remittance.id
        self.push(viewController: viewController)
    }
    
}
