//
//  ToastView.swift
//  Canow
//
//  Created by hieplh2 on 27/12/2021.
//

import UIKit

class ToastView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel! {
        didSet {
            self.messageLabel.text = StringConstants.internetMessageDisconnected.localized
        }
    }
    
    // MARK: - Properties
    var icon: UIImage? {
        didSet {
            self.iconImageView.image = self.icon
        }
    }
    var message: String? {
        didSet {
            self.messageLabel.text = self.message
        }
    }
    var messageColor: UIColor? {
        didSet {
            self.messageLabel.textColor = self.messageColor
        }
    }
    var bgColor: UIColor? {
        didSet {
            self.contentView.backgroundColor = self.bgColor
        }
    }
    var onClose: () -> Void = {}
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
}

// MARK: - Methods
extension ToastView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ToastView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}

// MARK: - Actions
extension ToastView {
    
    @IBAction func actionClose(_ sender: Any) {
        self.onClose()
    }
    
}
