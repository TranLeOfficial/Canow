//
//  NewsDetailViewController.swift
//  Canow
//
//  Created by PhuNT14 on 14/11/2021.
//
//  Screen ID: S19002

import UIKit
import WebKit

var MyObservationContext = 0
class NewsDetailViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var headerView: BaseHeaderView! {
        didSet {
            self.headerView.onBack = {
                self.pop()
            }
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.layer.cornerRadius = 20
            self.scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            self.nameLabel.font = .font(with: .bold700, size: 16)
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.font = .font(with: .medium500, size: 14)
            self.dateLabel.textColor = .color646464
        }
    }
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            self.webView.scrollView.showsVerticalScrollIndicator = false
            self.webView.scrollView.showsHorizontalScrollIndicator = false
            self.webView.navigationDelegate = self
            self.webView.scrollView.isScrollEnabled = false
            self.webView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let viewModel = NewsDetailViewModel()
    var newID: Int = 0
    var observing = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        CommonManager.showLoading()
    }
    
    // MARK: - Override Methods
    override func bindViewAndViewModel() {
        self.reloadData()
        getNewDetailSuccess()
        getNewDetailFailure()
    }
    
    deinit {
        self.stopObservingHeight()
    }
    
}

// MARK: Methods
extension NewsDetailViewController {
    
    private func setupUI() {
        self.viewModel.getNewDetail(newsId: newID)
    }
    
    private func reloadData() {
        self.viewModel.fetchNewsDetailSuccess = { newDetaiInfo in
            self.imgView?.kf.setImage(with: CommonManager.getImageURL(newDetaiInfo.image))
            self.headerView.setTitle(title: newDetaiInfo.name)
            self.nameLabel.text = newDetaiInfo.name
            self.dateLabel.text = self.convertDateToString(stringDate: newDetaiInfo.availableFrom)
            let fontSize = 40
            let fontSetting = "<span style=\"font-size: \(fontSize);word-wrap: break-word\"</span>"
            self.webView.loadHTMLString(fontSetting + newDetaiInfo.content, baseURL: nil)
        }
    }
    
    private func getNewDetailSuccess() {
        self.viewModel.getNewDetailSuccess = {
            print(self.viewModel.new as Any)
            CommonManager.hideLoading()
        }
    }
    
    private func getNewDetailFailure() {
        self.viewModel.getNewDetailFailure = { error in
            self.showAlert(title: "Error", message: "get New Detail failure\n\(error.debugDescription)", actions: ("OK", {
                self.pop()
            }))
            CommonManager.hideLoading()
        }
    }
    
    private func convertDateToString(stringDate: String?) -> String {
        if let date: Date = stringDate?.toDate(dateFormat: DateFormat.DATE_CURRENT) {
            let string: String = date.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
            return string
        }
        return ""
    }
    
    // Height webview
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.new])
        self.webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "contentSize":
            if context == &MyObservationContext {
                webviewHeightConstraint.constant = self.webView.scrollView.contentSize.height
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func stopObservingHeight() {
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
}

// MARK: - WebView
extension NewsDetailViewController: WKNavigationDelegate, UIWebViewDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard case .linkActivated = navigationAction.navigationType,
              let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        if url.absoluteString.contains(Constants.DEEP_LINK_URL) {
            let userActivity =  NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
            userActivity.webpageURL = url
            let checkuserActivity = UIApplication.shared.delegate?.application?(UIApplication.shared, continue: userActivity, restorationHandler: { _ in }) ?? false
            if !checkuserActivity {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webviewHeightConstraint.constant = webView.scrollView.contentSize.height
        if (!observing) {
            self.startObservingHeight()
        }
    }
}
