//
//  PersonalCell.swift
//  Canow
//
//  Created by NhanTT13 on 11/10/21.
//

import UIKit
import Localize

class PersonalCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.font = .font(with: .medium500, size: 16)
            self.titleLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    
    // MARK: - Override methods
    override func configure<T>(data: T, indexPath: IndexPath) {
        guard let data = data as? PersonalData else { return }
        
        self.titleLabel.text = data.title
        self.iconImageView.image = UIImage(named: data.icon)
        
        switch indexPath.section {
        case 1, 2:
            self.containerView.layer.maskedCorners = [.layerMinXMinYCorner,
                                                      .layerMaxXMinYCorner,
                                                      .layerMinXMaxYCorner,
                                                      .layerMaxXMaxYCorner]
        case 3:
            if indexPath.row == 0 {
                self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                self.separatorView.isHidden = false
            } else {
                self.containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        case 4:
            if indexPath.row == 0 {
                self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                self.languageLabel.isHidden = false
                self.languageLabel.text = Localize.currentLanguage == "ja" ?
                StringConstants.s07JanpaneseLanguage.localized :
                StringConstants.s07EnglishLanguage.localized
            } else {
                self.containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        case 5:
            self.containerView.layer.maskedCorners = [.layerMinXMinYCorner,
                                                      .layerMaxXMinYCorner,
                                                      .layerMinXMaxYCorner,
                                                      .layerMaxXMaxYCorner]
            self.chevronImageView.isHidden = true
        default:
            break
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.iconImageView.image = nil
        
        self.chevronImageView.isHidden = false
        
        self.languageLabel.isHidden = true
    }
    
}
