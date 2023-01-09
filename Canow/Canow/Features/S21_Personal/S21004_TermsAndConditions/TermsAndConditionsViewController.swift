//
//  TermsAndConditionsViewController.swift
//  Canow
//
//  Created by PhuNT14 on 25/10/2021.
//
//  Screen ID: S01002

import WebKit
import UIKit

class TermsAndConditionsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s01TitleTermConditions.localized)
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
            self.webView.scrollView.showsVerticalScrollIndicator = false
            self.webView.scrollView.showsHorizontalScrollIndicator = false
            self.webView.navigationDelegate = self
            self.webView.allowsBackForwardNavigationGestures = true
            
        }
    }
    
    // MARK: - Properties
    private let viewModel = TermsAndConditionsViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        getTermsAndConditionsSuccess()
        getTermsAndConditionsFailure()
    }
    
}

// MARK: - Methods
extension TermsAndConditionsViewController {
    
    private func setupUI() {
        self.title = StringConstants.termsAndConditions.localized
        self.viewModel.getTermsAndConditions()
    }
    
    func getTermsAndConditionsSuccess() {
        self.viewModel.getTermsAndConditionsSuccess = {
            self.webView.loadHTMLString(CommonManager.getHTML(data: self.viewModel.termsAndConditionsData), baseURL: nil)
            CommonManager.hideLoading()
        }
    }
    
    func getTermsAndConditionsFailure() {
        self.viewModel.getTermsAndConditionsFailure = { error in
            self.showAlert(title: "Error", message: "get Term & Condition failure\n\(error.debugDescription)", actions: ("OK", {
                self.pop()
            }))
            CommonManager.hideLoading()
        }
    }
    
}

extension TermsAndConditionsViewController: WKNavigationDelegate, UIWebViewDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard case .linkActivated = navigationAction.navigationType,
              let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
