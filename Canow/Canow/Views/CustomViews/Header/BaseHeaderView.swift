//
//  BaseHeaderView.swift
//  Canow
//
//  Created by TuanBM6 on 03/11/2021.
//

import UIKit

class BaseHeaderView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var rightButton: UIButton! {
        didSet {
            self.rightButton.setTitle(StringConstants.s03LbSkip.localized, for: .normal)
            self.rightButton.setTitle(StringConstants.s03LbSkip.localized, for: .highlighted)
            self.rightButton.titleLabel?.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - Properties
    var backButtonHidden: Bool = false {
        didSet {
            self.backButton.isHidden = self.backButtonHidden
        }
    }
    var rightButtonHidden: Bool = true {
        didSet {
            self.rightButton.isHidden = self.rightButtonHidden
        }
    }
    var titleAlignment: NSTextAlignment = .center {
        didSet {
            self.nameLabel.textAlignment = self.titleAlignment
        }
    }
    var backButtonImage: UIImage? = UIImage(named: "ic_back") {
        didSet {
            self.backButton.setTitle(nil, for: .normal)
            self.backButton.setTitle(nil, for: .highlighted)
            self.backButton.setImage(self.backButtonImage, for: .normal)
            self.backButton.setImage(self.backButtonImage, for: .highlighted)
        }
    }
    var rightButtonTitle: String? = nil {
        didSet {
            self.rightButton.setTitle(self.rightButtonTitle, for: .normal)
            self.rightButton.setTitle(self.rightButtonTitle, for: .highlighted)
            self.rightButton.setImage(nil, for: .normal)
            self.rightButton.setImage(nil, for: .highlighted)
        }
    }
    var rightButtonImage: UIImage? = nil {
        didSet {
            self.rightButton.setTitle(nil, for: .normal)
            self.rightButton.setTitle(nil, for: .highlighted)
            self.rightButton.setImage(self.rightButtonImage, for: .normal)
            self.rightButton.setImage(self.rightButtonImage, for: .highlighted)
        }
    }
    var bgColor: UIColor? = .clear {
        didSet {
            self.contentView.backgroundColor = self.bgColor
        }
    }
    var onBack: () -> Void = {}
    var onPressRightButton: () -> Void = {}
    
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
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
    
}

// MARK: - Methods
extension BaseHeaderView {
    
    private func commonInit() {
        Bundle.main.loadNibNamed("BaseHeaderView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
    func setTitle(title: String,
                  color: UIColor? = nil,
                  font: UIFont = .font(with: .bold700, size: 16)) {
        self.nameLabel.text = title
        self.nameLabel.textColor = color != nil ? color : self.themeInfo.textColor
        self.nameLabel.font = font
        
        self.rightButton.imageView?.setImageColor(color != nil ? color : self.themeInfo.textColor)
        self.backButton.imageView?.setImageColor(color != nil ? color : self.themeInfo.textColor)
        
        self.rightButton.tintColor = color != nil ? color : self.themeInfo.textColor
        self.backButton.tintColor = color != nil ? color : self.themeInfo.textColor
    }
    
    func setRightButtonTitle(title: String) {
        self.rightButton.setTitle(title, for: .normal)
    }
    
    func updateUI() {
        self.nameLabel.textColor = self.themeInfo.textColor
    }
    
    func collapse(fullText: String) {
        var arrayString = Array(fullText)
        let titleTransfer = "...\(StringConstants.s05TitleTransferTo.localized)"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.colorBlack111111, NSAttributedString.Key.font: UIFont.font(with: .bold700, size: 16)]
        
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.colorBlack111111, NSAttributedString.Key.font: UIFont.font(with: .bold700, size: 16)]
        
        let title = NSMutableAttributedString(string: titleTransfer, attributes: titleAttributes)
        let decriptionAttibuted = NSMutableAttributedString(string: fullText, attributes: textAttributes)
        decriptionAttibuted.append(title)
        self.nameLabel.attributedText = decriptionAttibuted
        if self.nameLabel.calculateMaxLines() <= 1 {
            self.nameLabel.text = fullText + StringConstants.s05TitleTransferTo.localized
            return
        }
        
        self.nameLabel.text = ""
        var decriptionText = ""
        var string = ""
        for item in arrayString where self.nameLabel.calculateMaxLines() <= 1 {
            decriptionText += "\(String(item))"
            string += "\(String(item))\(titleTransfer)"
            let info = NSMutableAttributedString(string: string, attributes: textAttributes)
            self.nameLabel.attributedText = info
            string = decriptionText
        }
        
        arrayString = Array(decriptionText)
        decriptionText = ""
        let array = arrayString[0...(arrayString.count - titleTransfer.count * 2)]
        for item in array {
            decriptionText += "\(item)"
        }
        decriptionText += " "
        let decription = NSMutableAttributedString(string: decriptionText, attributes: textAttributes)
        decription.append(title)
        self.nameLabel.attributedText = decription
    }
    
}

// MARK: - Actions
extension BaseHeaderView {
    
    @IBAction func onBack(_ sender: UIButton) {
        self.onBack()
    }
    
    @IBAction func actionRightButton(_ sender: Any) {
        self.onPressRightButton()
    }
    
}
