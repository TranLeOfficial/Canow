//
//  ResetPasswordSuccessfull.swift
//  Canow
//
//  Created by NhanTT13 on 10/25/21.
//

import UIKit

class ResetPasswordSuccessfull: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 6
            self.loginButton.backgroundColor = .colorYellowFFCC00
            self.loginButton.tintColor = .colorBlack111111
            self.loginButton.setTitle(StringConstants.s02BtnLogin.localized, for: .normal)
            self.loginButton.setTitle(StringConstants.s02BtnLogin.localized, for: .highlighted)
        }
    }
    @IBOutlet private weak var passwordChangedLabel: UILabel! {
        didSet {
            self.passwordChangedLabel.textColor = .colorBlack111111
            self.passwordChangedLabel.font = .font(with: .bold700, size: 16)
            self.passwordChangedLabel.text = StringConstants.s02PasswordChanged.localized
        }
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction private func doneReset(_ sender: UIButton) {
        self.navigationController?.viewControllers.forEach({ (vc) in
            if  let loginViewController = vc as? LoginViewController {
                self.popTo(viewController: loginViewController)
            }
        })
    }
    
}
