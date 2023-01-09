//
//  InformGMOViewController.swift
//  Canow
//
//  Created by TuanBM6 on 11/26/21.
//
//  Screen ID: S06002

import UIKit

protocol InformGCMConfirm:AnyObject {
    func confirmGuideline()
}

class InformGMOViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var confirmButton: CustomButton! {
        didSet {
            self.confirmButton.layer.cornerRadius = 6
            self.confirmButton.setupUI()
        }
    }
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet private weak var informLabel: UILabel! {
        didSet {
            self.informLabel.font = .font(with: .bold700, size: 12)
            self.informLabel.textColor = .colorBlack111111
            self.informLabel.text = StringConstants.s04GMOMessage.localized
        }
    }
    
    // MARK: - Properties
    weak var delegate: InformGCMConfirm?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.confirmButton.setupUI()
    }
}

// MARK: - Actions
extension InformGMOViewController {
    
    @IBAction func confirm(_ sender: UIButton) {
        self.delegate?.confirmGuideline()
        self.dismiss(animated: false)
    }
    
}

// MARK: - Methods
extension InformGMOViewController {
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissInformGMO))
        self.view.addGestureRecognizer(tapGesture)
        self.confirmButton.setTitle(StringConstants.s04Continue.localized, for: .normal)
        self.confirmButton.setTitle(StringConstants.s04Continue.localized, for: .highlighted)
    }
    
    @objc private func dismissInformGMO() {
        self.dismiss(animated: false)
    }
    
}
