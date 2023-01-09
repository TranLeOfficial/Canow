//
//  CouponLandingPageViewController.swift
//  Canow
//
//  Created by TuanBM6 on 2/7/22.
//

import UIKit

class CouponLandingPageViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var purchasedTableView: UITableView! {
        didSet {
            self.purchasedTableView.delegate = self
            self.purchasedTableView.dataSource = self
            self.purchasedTableView.registerReusedCell(cellNib: NotPurchasedTableViewCell.self)
            self.purchasedTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }
    @IBOutlet private weak var notificationNoDataLabel: UILabel! {
        didSet {
            self.notificationNoDataLabel.text = StringConstants.s11MessageNoCoupon.localized
            self.notificationNoDataLabel.font = .font(with: .medium500, size: 14)
            self.notificationNoDataLabel.textColor = .colorBlack111111
            self.notificationNoDataLabel.isHidden = true
        }
    }
    
    // MARK: - Properties
    private let viewModel = CouponLandingPageViewModel()
    private var teamId: Int?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }

}

// MARK: - Methods
extension CouponLandingPageViewController {
    
    private func getNotPurchasedData() {
        guard let merchantInfo = DataManager.shared.getMerchantInfo() else {
            return
        }
        self.teamId = merchantInfo.id
        self.viewModel.getListCouponAvailable(partnerId: merchantInfo.id)
    }
    
    private func reloadData() {
        self.viewModel.fetchDataSuccess = {
            CommonManager.hideLoading()
            self.viewModel.notPurchasedData.isEmpty ? (self.notificationNoDataLabel.isHidden = false) : (self.notificationNoDataLabel.isHidden = true)
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
        self.getNotPurchasedData()
    }
    
    private func checkCustomerInfor() {
        let customerInfo = DataManager.shared.getCustomerInfo()
        if customerInfo == nil {
            self.viewModel.notPurchasedData.removeAll()
            self.purchasedTableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CouponLandingPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.notPurchasedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: NotPurchasedTableViewCell.self, indexPath: indexPath)
        let data = self.viewModel.notPurchasedData[indexPath.row]
        cell?.configure(data: data)
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coupon = self.viewModel.notPurchasedData[indexPath.row]
        self.push(viewController: CouponViewController(type: .redeem,
                                                       eCouponId: coupon.eCouponId,
                                                       fantokenTicker: coupon.fantokenTicker))
    }
    
}
