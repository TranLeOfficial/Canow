//
//  HomeTeamInfoViewController.swift
//  Canow
//
//  Created by PhucNT34 on 1/14/22.
//

import UIKit
import Kingfisher
import WebKit

class HomeTeamInfoViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var headerView: UIView! {
        didSet {
            self.headerView.layer.cornerRadius = 20
            self.headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var nameFavoriteTeamLabel: UILabel! {
        didSet {
            self.nameFavoriteTeamLabel.font = .font(with: .medium500, size: 16)
            self.nameFavoriteTeamLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var closeImageView: UIImageView! {
        didSet {
            self.closeImageView.image = UIImage(named: "ic_close")
            self.closeImageView.isUserInteractionEnabled = true
            self.closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClose)))
        }
    }
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var gradientImageView: UIImageView! {
        didSet {
            self.gradientImageView.image = UIImage(named: "bg_cf_image_gradient")
        }
    }
    @IBOutlet private weak var webView: WKWebView! {
        didSet {
            self.webView.scrollView.showsVerticalScrollIndicator = false
            self.webView.scrollView.showsHorizontalScrollIndicator = false
            self.webView.navigationDelegate = self
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
    }
    
}

// MARK: - Methods
extension HomeTeamInfoViewController {
    
    private func setupData() {
        guard let teamInfor = DataManager.shared.getMerchantInfo() else {
            return
        }
        guard let htmlString = teamInfor.description else {
            return
        }
        self.nameFavoriteTeamLabel.text = teamInfor.name
        self.bannerImageView.kf.setImage(with: CommonManager.getImageURL(teamInfor.cover))
        let fontName =  "PFHandbookPro-Regular"
        let fontSize = 30
        let fontSetting = "<span style=\"font-family: \(fontName);font-size: \(fontSize);word-wrap: break-word\"</span>"
        self.webView.loadHTMLString(fontSetting + htmlString, baseURL: nil)
    }
    
}

// MARK: - Helpers
extension HomeTeamInfoViewController {
    
    @objc private func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Actions
extension HomeTeamInfoViewController {
    
}

// MARK: - WebView
extension HomeTeamInfoViewController: WKNavigationDelegate, UIWebViewDelegate {
    
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
            self.dismiss(animated: true)
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
