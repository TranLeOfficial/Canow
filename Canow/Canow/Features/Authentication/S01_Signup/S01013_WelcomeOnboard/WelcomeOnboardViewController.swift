//
//  WelcomeOnboardViewController.swift
//  Canow
//
//  Created by PhuNT14 on 21/10/2021.
//
//  Screen ID: S01013

import UIKit

class WelcomeOnboardViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var letgoButton: UIButton! {
        didSet {
            self.letgoButton.layer.cornerRadius = 6
            self.letgoButton.backgroundColor = .colorYellowFFCC00
            self.letgoButton.setTitleColor(.colorBlack111111, for: .normal)
            self.letgoButton.setTitleColor(.colorBlack111111, for: .highlighted)
            self.letgoButton.titleLabel?.font = .font(with: .bold700, size: 16)
            self.letgoButton.titleLabel?.text = StringConstants.s01BtnLetgo.localized
        }
    }
    
    @IBOutlet private weak var welcomeLabel: UILabel! {
        didSet {
            self.welcomeLabel.textColor = .colorBlack111111
            self.welcomeLabel.font = .font(with: .bold700, size: 24)
            self.welcomeLabel.text = StringConstants.s01LbWelcomeOnboard.localized
        }
    }
    
    @IBOutlet private weak var readyLabel: UILabel! {
        didSet {
            self.readyLabel.textColor = .colorBlack111111
            self.readyLabel.font = .font(with: .bold700, size: 18)
            self.readyLabel.text = StringConstants.s01LbReady.localized
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Actions
extension WelcomeOnboardViewController {
    
    @IBAction func showHome(_ sender: Any) {
        self.navigationController?.viewControllers.forEach({ (vc) in
            if  let viewController = vc as? LoginViewController {
                self.popTo(viewController: viewController)
            }
        })
    }
    
}
