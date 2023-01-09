//
//  PayCouponUseViewController.swift
//  Canow
//
//  Created by NhanTT13 on 12/23/21.
//

import UIKit

class PayCouponUseViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var useCouponTableView: UITableView! {
        didSet {
            self.useCouponTableView.dataSource = self
            self.useCouponTableView.delegate = self
            self.useCouponTableView.registerReusedCell(cellNib: UseCouponTableViewCell.self)
            self.useCouponTableView.separatorStyle = .none
            self.useCouponTableView.reloadData()
        }
    }
    @IBOutlet weak var payWithoutCouponLabel: UILabel! {
        didSet {
            self.payWithoutCouponLabel.underline()
            self.payWithoutCouponLabel.text = StringConstants.s06PayWithoutCoupn.localized
            self.payWithoutCouponLabel.isUserInteractionEnabled = true
            self.payWithoutCouponLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCouponWithout)))
        }
    }
    
    @IBOutlet weak var noCouponLabel: UILabel! {
        didSet {
            self.noCouponLabel.text = StringConstants.s06MessageNoCoupon.localized
        }
    }
    
    // MARK: - Properties
    var footerCell: UseCouponFooterCell?
    var merchantId: Int?
    private let viewModel = PayCouponUseViewModel()
    var payVC: PayViewController?
    var segmentIndex = 0
    var onSegmentIndex: () -> Void = { }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
        self.reloadData()
    }
    
    // MARK: - Override Method
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fechDataFailure()
    }
    
}

// MARK: - Methods
extension PayCouponUseViewController {
    
    private func updateUI() {
        let frameFooter = CGRect(x: 0, y: 100, width: view.frame.width, height: 60)
        footerCell = UseCouponFooterCell(frame: frameFooter)
        footerCell?.setupLabel(text: StringConstants.s06PayWithoutCoupn.localized, color: .black, font: .font(with: .bold700, size: 14))
        useCouponTableView.tableFooterView = footerCell
        let tapFooter = UITapGestureRecognizer(target: self, action: #selector(tapFooterFunc))
        self.footerCell?.addGestureRecognizer(tapFooter)
        
        if let merchantId = self.merchantId {
            CommonManager.showLoading()
            self.viewModel.getListCouponByMerchantId(merchantId: merchantId)
            self.viewModel.getMerchantById(merchantId: merchantId)
        }
        self.useCouponTableView.reloadData()
    }
    
    private func reloadData() {
        self.viewModel.getListCouponSuccess = {
            CommonManager.hideLoading()
            self.useCouponTableView.isHidden = self.viewModel.listCoupon.isEmpty
            self.useCouponTableView.reloadData()
        }
        self.viewModel.getMerchantInfoSuccess = { merchant in
            DataManager.shared.saveMerchantInfo(merchant)
        }
        
        self.viewModel.getECouponDetailSuccess = {
            let transactionConfirmVC = TransactionConfirmViewController(transactionType: .pay)
            transactionConfirmVC.eCouponInfo = self.viewModel.eCouponInfo
            transactionConfirmVC.payType = .payDiscountCoupon
            self.push(viewController: transactionConfirmVC)
        }
    }
    
    private func fechDataFailure() {
        self.viewModel.fetchDataFailure = { error in
            CommonManager.hideLoading()
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
}

// MARK: - Actions
extension PayCouponUseViewController {
    
    @objc func tapFooterFunc() {
        self.onSegmentIndex()
    }
    
    @objc func tapCouponWithout() {
        self.onSegmentIndex()
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PayCouponUseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listCoupon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: UseCouponTableViewCell.self, indexPath: indexPath)
        cell?.configure(data: self.viewModel.listCoupon[indexPath.row])
        cell?.dropShadow()
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coupon = self.viewModel.listCoupon[indexPath.row]
        
        if Int(coupon.payPrice) ?? 0 > 0 {
            let paymentVC = PaymentViewController()
            paymentVC.coupon = coupon
            self.push(viewController: paymentVC)
        } else {
            self.viewModel.getEcouponDetail(eCouponId: coupon.eCouponId)
        }
        self.useCouponTableView.reloadData()
    }
    
}
