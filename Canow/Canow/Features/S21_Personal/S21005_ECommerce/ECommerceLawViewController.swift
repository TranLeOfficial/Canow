//
//  ECommerceLawViewController.swift
//  Canow
//
//  Created by PhuNT14 on 27/10/2021.
//

import UIKit
import WebKit

class ECommerceLawViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s07EcommerceLaw.localized)
            self.headerView.onBack = {
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
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            self.webView.backgroundColor = .clear
            self.webView.isOpaque = false
        }
    }
    
    // MARK: - Properties
    private let viewModel = ECommerceLawViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        getECommerceLawSuccess()
        getECommerceLawFailure()
    }
    
}

// MARK: - Methods
extension ECommerceLawViewController {
    
    private func setupUI() {
        self.title = "E-Commerce Law"
        self.viewModel.getTermsAndConditions()
    }
    
    func getECommerceLawSuccess() {
        self.viewModel.getECommerceLawSuccess = {
            print("get E-Commerce Law successfully")
            self.webView.loadHTMLString(CommonManager.getHTML(data: self.viewModel.ECommerceLawData), baseURL: nil)
            CommonManager.hideLoading()
        }
    }
    
    func getECommerceLawFailure() {
        self.viewModel.getECommerceLawFailure = { error in
            CommonManager.hideLoading()
            self.showAlert(title: "Error",
                           message: "get E-Commerce Law failure\n\(error.debugDescription)",
                           actions: ("OK", {
                self.pop()
            }))
        }
    }
    
}
