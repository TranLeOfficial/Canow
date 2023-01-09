//
//  HistoryViewController.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//
//  Screen ID: S20000

import UIKit

class HistoryViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.transactionHistory.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet private weak var historyTableView: UITableView! {
        didSet {
            self.historyTableView.dataSource = self
            self.historyTableView.delegate = self
            self.historyTableView.separatorStyle = .none
            self.historyTableView.registerReusedCell(cellNib: HistoryCell.self, bundle: nil)
        }
    }
    
    // MARK: - Properties
    private let viewModel = HistoryViewModel()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    private var heightCell: CGFloat = 78
    private var pageIndex: Int = 0
    private var pageSize: Int = 20
    private var historyData = [HistoryInfo]()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: Methods
extension HistoryViewController {
    
    private func setupData() {
        self.view.backgroundColor = self.themeInfo.primaryColor
        self.viewModel.getListHistory(tokenType: "",
                                      pageIndex: pageIndex,
                                      pageSize: pageSize)
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            for item in self.viewModel.listHistory {
                self.historyData.append(item)
            }
            self.historyTableView.reloadData()
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
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: HistoryCell.self)
        let data = self.historyData[indexPath.row]
        cell?.configure(data: data)
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyDetailVC = HistoryDetailViewController()
        historyDetailVC.historyInfo = self.historyData[indexPath.row]
        self.push(viewController: historyDetailVC)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.historyData.count - 5 {
            if pageIndex <= self.historyData.count - 1 {
                pageIndex += 1
                self.viewModel.getListHistory(tokenType: "",
                                              pageIndex: pageIndex,
                                              pageSize: pageSize)
            }
        }
    }
}
