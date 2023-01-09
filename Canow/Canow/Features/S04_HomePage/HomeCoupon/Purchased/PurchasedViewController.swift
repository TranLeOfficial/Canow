//
//  PurchasedViewController.swift
//  Canow
//
//  Created by PhucNT34 on 1/12/22.
//

import UIKit

class PurchasedViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var purchasedTableView: UITableView! {
        didSet {
            self.purchasedTableView.delegate = self
            self.purchasedTableView.dataSource = self
            self.purchasedTableView.registerReusedCell(cellNib: PurchasedTableViewCell.self)
            self.purchasedTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }
    @IBOutlet private weak var notificationNoDataLabel: UILabel! {
        didSet {
            self.notificationNoDataLabel.text = StringConstants.s11MessageNoCoupon.localized
            self.notificationNoDataLabel.font = .font(with: .medium500, size: 14)
            self.notificationNoDataLabel.textColor = .color646464
            self.notificationNoDataLabel.isHidden = true
        }
    }
    
    // MARK: - Properties
    private let viewModel = PurchasedViewModel()
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
            self.viewModel.purchasedData.removeAll()
            self.purchasedTableView.reloadData()
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
extension PurchasedViewController {
    
    private func getPurchasedData() {
        switch DataManager.shared.isFanToken() {
        case .fanToken, .redEnvelope:
            guard let merchantInfo = DataManager.shared.getMerchantInfo() else {
                return
            }
            self.teamId = merchantInfo.id
            self.viewModel.getListCouponPurchased(partnerId: merchantInfo.id)
        default:
            guard let customerInfo = DataManager.shared.getCustomerInfo() else {
                return
            }
            self.teamId = customerInfo.teamId
            self.viewModel.getListCouponPurchased(partnerId: customerInfo.teamId)
        }
        
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
            self.viewModel.purchasedData.isEmpty ? (self.notificationNoDataLabel.isHidden = false) : (self.notificationNoDataLabel.isHidden = true)
            self.purchasedTableView.reloadData()
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
        self.getPurchasedData()
        self.purchasedTableView.reloadData()
    }
    
    private func checkCustomerInfor() {
        let customerInfo = DataManager.shared.getCustomerInfo()
        if customerInfo == nil {
            self.viewModel.purchasedData.removeAll()
            self.purchasedTableView.reloadData()
        }
    }
    
}

// MARK: - Actions
extension PurchasedViewController {
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PurchasedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.purchasedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: PurchasedTableViewCell.self, indexPath: indexPath)
        let data = self.viewModel.purchasedData[indexPath.row]
        cell?.configure(data: data)
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coupon = self.viewModel.purchasedData[indexPath.row]
        let couponViewType: CouponViewType  = coupon.type == "AirdropCoupon" ? .airdrop : .use
        self.push(viewController: CouponViewController(type: couponViewType,
                                                       eCouponId: coupon.eCouponId,
                                                       fantokenTicker: coupon.fantokenTicker)
        )
    }
}
