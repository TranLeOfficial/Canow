//
//  BackgroundView.swift
//  Canow
//
//  Created by hieplh2 on 12/01/2022.
//

import UIKit

class BackgroundView: UIView {
    
    // MARK: - Properties
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
extension BackgroundView {
    
    private func commonInit() {
        self.backgroundColor = self.themeInfo.primaryColor
    }
    
}
