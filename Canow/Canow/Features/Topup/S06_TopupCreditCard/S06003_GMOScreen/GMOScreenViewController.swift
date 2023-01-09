//
//  GMOScreenViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/26/21.
//
//  Screen ID: S06003

import UIKit
import WebKit

class GMOScreenViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.topUpCard.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }

    @IBOutlet private weak var webView: WKWebView!
    
    // MARK: - Properties
    var externalLink: String = ""
    var amount: String = ""
    private var observationEstimated: NSKeyValueObservation?
    private var observationURL: NSKeyValueObservation?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        self.setupUI()
    }
    
    deinit {
        self.observationEstimated = nil
        self.observationURL = nil
    }
    
}

// MARK: - Methods
extension GMOScreenViewController {
    
    private func setupUI() {
        self.view.backgroundColor = .colorYellowFFCC00
    }
    
    private func setupWebView() {
        self.tabBarController?.tabBar.isHidden = true
        
        self.trackInitialPageLoadProgress()
        guard let url = URL(string: externalLink) else { return }
        self.webView.load(URLRequest(url: url))
    }
    
    private func trackInitialPageLoadProgress() {
        self.observationEstimated = webView.observe(\.estimatedProgress, options: [.new]) { webview, _ in
            if webview.estimatedProgress == 1.0 {
                CommonManager.hideLoading()
            }
        }
        self.observationURL = self.webView.observe(\.url, options: [.new]) { _, change in
            CommonManager.showLoading()
            guard let urlString = change.newValue.unsafelyUnwrapped?.absoluteString else {
                return
            }
            if urlString.contains(Endpoint.topupByCard) {
                let transaction = urlString.split(separator: "/")
                guard let transactionID =  String(transaction[transaction.count - 1]).base64Decoded() else {
                    self.pop()
                    return
                }
                self.observationEstimated = nil
                self.observationURL = nil
                CommonManager.hideLoading()
                let viewController = TransactionStatusViewController()
                viewController.transactionId = transactionID
                viewController.transactionType = .topUp
                viewController.topUpType = .creditCard
                self.push(viewController: viewController)
            }
        }
    }
    
}
