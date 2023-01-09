//
//  LoginView.swift
//  Canow
//
//  Created by TuanBM6 on 2/7/22.
//

import UIKit

class LoginView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var loginView: UIView! {
        didSet {
            self.loginView.clipsToBounds = true
            self.loginView.layer.cornerRadius = 16
        }
    }
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            self.backButton.setTitle(StringConstants.s07BtnLater.localized, for: .normal)
            self.backButton.setTitle(StringConstants.s07BtnLater.localized, for: .highlighted)
            self.backButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.backButton.setTitleColor(.colorBlack111111, for: .normal)
            self.backButton.backgroundColor = .colorE5E5E5
            self.backButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var LoginButton: UIButton! {
        didSet {
            self.LoginButton.setTitle(StringConstants.s01LandingPageLogin.localized, for: .normal)
            self.LoginButton.setTitle(StringConstants.s01LandingPageLogin.localized, for: .highlighted)
            self.LoginButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.LoginButton.setTitleColor(.colorBlack111111, for: .normal)
            self.LoginButton.backgroundColor = .colorYellowFFCC00
            self.LoginButton.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var loginLabel: UILabel! {
        didSet {
            self.loginLabel.text = StringConstants.s11MessagePleaseLogin.localized
            self.loginLabel.textColor = .colorBlack111111
            self.loginLabel.font = .font(with: .bold700, size: 14)
        }
    }
    
    // MARK: - Properties
    
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

extension LoginView {
    
    private func setupView() {
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}

extension LoginView {
       
    @IBAction func backAction(_ sender: UIButton) {
        CommonManager.hideLogin()
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Login, object: nil)
        CommonManager.hideLogin()
    }
    
}
