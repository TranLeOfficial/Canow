//
//  ProgressView.swift
//  Canow
//
//  Created by TuanBM6 on 11/2/21.
//

import UIKit

class ProgressView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            self.backgroundView.layer.cornerRadius = self.backgroundView.frame.height / 2
            self.backgroundView.backgroundColor = .colorE5E5E5
        }
    }
    @IBOutlet weak var percentView: UIView! {
        didSet {
            self.percentView.layer.cornerRadius = self.percentView.frame.height / 2
            percentView.backgroundColor = .colorGreen339A06
        }
    }
    @IBOutlet weak var percentLabel: UILabel! {
        didSet {
            self.percentLabel.font = .font(with: .bold700, size: 12)
            self.percentLabel.textColor = .colorGreen339A06
        }
    }
    @IBOutlet weak var percentViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var current: Double = 0 {
        didSet {
            self.updateUI()
        }
    }
    
    var total: Double = 0 {
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
        self.updateUI()
    }
    
}

// MARK: - Methods
extension ProgressView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2
        self.percentView.layer.cornerRadius = (self.contentView.frame.height - 10) / 2
        self.updateUI()
    }
    
    func updateUI() {
        if self.total > 0 {
            let percent = self.current * 100 / self.total
            self.percentLabel.text = "\(Int(percent))%"
            self.percentViewWidthConstraint.constant = self.current >= self.total ? self.contentView.frame.width : CGFloat(self.current) * self.contentView.frame.width / CGFloat(self.total)
        }
    }
    
}
