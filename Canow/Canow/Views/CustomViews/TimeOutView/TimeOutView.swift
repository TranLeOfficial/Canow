//
//  TimeOutView.swift
//  Canow
//
//  Created by TuanBM6 on 3/3/22.
//

import UIKit
import Localize

class TimeOutView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var loginView: UIView! {
        didSet {
            self.loginView.clipsToBounds = true
            self.loginView.layer.cornerRadius = 16
        }
    }
    @IBOutlet private weak var skipButton: UIButton! {
        didSet {
            self.skipButton.setTitle(StringConstants.s03LbSkip.localized, for: .normal)
            self.skipButton.setTitle(StringConstants.s03LbSkip.localized, for: .highlighted)
            self.skipButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.skipButton.setTitleColor(.colorBlack111111, for: .normal)
            self.skipButton.backgroundColor = .white
            self.skipButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet weak private var LoginButton: UIButton! {
        didSet {
            self.LoginButton.setTitle(StringConstants.btnLoginTimeoutView.localized, for: .normal)
            self.LoginButton.setTitle(StringConstants.btnLoginTimeoutView.localized, for: .highlighted)
            self.LoginButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.LoginButton.layer.cornerRadius = 6
            self.LoginButton.setTitleColor(.colorBlack111111, for: .normal)
            self.LoginButton.setTitleColor(.colorBlack111111, for: .highlighted)
            self.LoginButton.backgroundColor = .colorYellowFFCC00
        }
    }
    @IBOutlet private weak var loginLabel: UILabel! {
        didSet {
            self.loginLabel.text = StringConstants.s11MessageTimeOut.localized
            self.loginLabel.textColor = .colorBlack111111
            self.loginLabel.font = .font(with: .bold700, size: 14)
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: ScreenSize.screenHeight))
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: ScreenSize.screenHeight))
        self.setupView()
    }
    
}

extension TimeOutView {
    
    private func setupView() {
        Bundle.main.loadNibNamed("TimeOutView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}

extension TimeOutView {
       
    @IBAction func skipAction(_ sender: UIButton) {
        Localize.update(language: UserDefaultManager.language ?? Localize.currentLanguage)
        NotificationCenter.default.post(name: NSNotification.backHomePage, object: nil)
        CommonManager.hideTimeOut()
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        Localize.update(language: UserDefaultManager.language ?? Localize.currentLanguage)
        NotificationCenter.default.post(name: NSNotification.Login, object: nil)
        CommonManager.hideTimeOut()
    }
    
}
