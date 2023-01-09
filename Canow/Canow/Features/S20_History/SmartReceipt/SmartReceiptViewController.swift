//
//  SmartReceiptViewController.swift
//  Canow
//
//  Created by TuanBM6 on 1/22/22.
//

import UIKit
import WebKit

class SmartReceiptViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.setTitle(title: StringConstants.s07SmartReceipt.localized)
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            self.webView.scrollView.showsVerticalScrollIndicator = false
            self.webView.scrollView.showsHorizontalScrollIndicator = false
            self.webView.navigationDelegate = self
            self.webView.layer.masksToBounds = true
        }
    }
    
    // MARK: - Properties
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    private let externalLink: String = "https://www.smartreceipt.jp/"
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
    }

}

// MARK: Methods
extension SmartReceiptViewController {
    
    private func setupWebView() {
        self.view.backgroundColor = self.themeInfo.primaryColor
        self.tabBarController?.tabBar.isHidden = true
        
        guard let url = URL(string: externalLink) else { return }
        self.webView.load(URLRequest(url: url))
    }
    
}

// MARK: - WebView
extension SmartReceiptViewController: WKNavigationDelegate, UIWebViewDelegate {
    
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
