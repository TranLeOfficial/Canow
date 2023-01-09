//
//  ProgressRedeemView.swift
//  Canow
//
//  Created by hieplh2 on 04/01/2022.
//

import UIKit

class ProgressRedeemView: UIView {

    // MARK: - Outlets
    @IBOutlet var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        }
    }
    @IBOutlet weak var currentProgressView: UIView! {
        didSet {
            self.currentProgressView.backgroundColor = .colorGreen339A06
            self.currentProgressView.layer.cornerRadius = self.contentView.frame.height / 2
            self.currentProgressView.backgroundColor = .color339A06
        }
    }
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var currentProgressWidth: NSLayoutConstraint!
    
    var current: Int = 0 {
        didSet {
            self.updateUI()
        }
    }
    
    var total: Int = 0 {
        didSet {
            self.updateUI()
        }
    }
    
    var remaining: Int = 0 {
        didSet {
            self.updateUI()
        }
    }
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.currentProgressView.backgroundColor = .colorGreen339A06
        self.currentProgressView.layer.cornerRadius = self.contentView.frame.height / 2
        self.currentProgressView.backgroundColor = .color339A06
    }
    
}

// MARK: - Methods
extension ProgressRedeemView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProgressRedeemView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.updateUI()
    }
    
    private func updateUI() {
        if self.total > 0 {
            if CommonManager.checkLanguageJP {
                self.progressLabel.text = "残り \(self.remaining)/\(self.total)"
            } else {
                self.progressLabel.text = "\(self.remaining)/\(self.total) LEFT"
            }
            self.currentProgressWidth.constant = CGFloat(self.remaining) * self.contentView.frame.width / CGFloat(self.total)
        }
    }
    
}
