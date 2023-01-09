//
//  CustomButton.swift
//  Canow
//
//  Created by hieplh2 on 12/01/2022.
//

import UIKit

class CustomButton: UIButton {
    
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
}

// MARK: - Methods
extension CustomButton {
    
    private func commonInit() {
        self.layer.cornerRadius = 6
        self.titleLabel?.font = .font(with: .bold700, size: 15)
        self.setTitleColor(self.themeInfo.buttonTextColor, for: .normal)
        self.setTitleColor(self.themeInfo.buttonTextColor, for: .highlighted)
        self.backgroundColor = self.themeInfo.secondaryColor
    }
    
    func setupUI() {
        self.setTitleColor(self.themeInfo.buttonTextColor, for: .normal)
        self.setTitleColor(self.themeInfo.buttonTextColor, for: .highlighted)
        self.backgroundColor = self.themeInfo.secondaryColor
    }
    
    func enable() {
        self.isUserInteractionEnabled = true
        self.setTitleColor(self.themeInfo.buttonTextColor, for: .normal)
        self.setTitleColor(self.themeInfo.buttonTextColor, for: .highlighted)
        self.backgroundColor = self.themeInfo.secondaryColor
    }
    
    func disable() {
        self.isUserInteractionEnabled = false
        self.setTitleColor(.color646464, for: .normal)
        self.setTitleColor(.color646464, for: .highlighted)
        self.backgroundColor = .colorE5E5E5
    }
    
}
