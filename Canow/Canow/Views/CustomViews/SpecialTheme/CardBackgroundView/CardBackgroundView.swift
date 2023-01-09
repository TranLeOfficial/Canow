//
//  CardBackgroundView.swift
//  Canow
//
//  Created by hieplh2 on 18/01/2022.
//

import UIKit

class CardBackgroundView: UIView {
    
    // MARK: - Properties
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    private let logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFill
        return logoImageView
    }()
    
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
extension CardBackgroundView {
    
    private func commonInit() {
        self.logoImageView.image = self.themeInfo.bgPattern4
        self.insertSubview(self.logoImageView, at: 0)
        
        self.logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(ScreenSize.screenWidth * 360 / 375)
            $0.leading.equalToSuperview().offset(100)
            $0.bottom.equalToSuperview().offset(-62)
        }
    }
    
}
