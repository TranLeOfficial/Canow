//
//  TeamSelectedCell.swift
//  Canow
//
//  Created by TuanBM6 on 12/15/21.
//

import UIKit

class TeamSelectedCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var nameTeamLabel: UILabel! {
        didSet {
            self.nameTeamLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var contentTeamView: UIView! {
        didSet {
            self.contentTeamView.clipsToBounds = true
            self.contentTeamView.backgroundColor = .white
            self.contentTeamView.configBorder(borderWidth: 1,
                                              borderColor: .colorE5E5E5,
                                              cornerRadius: self.contentTeamView.frame.height / 2)
        }
    }
    
    // MARK: - Properties
    var isCellSelected: Bool = false {
        didSet {
            self.contentTeamView.backgroundColor = self.isCellSelected ? self.themeInfo.selectedColor : .white
            self.contentTeamView.layer.borderColor = self.isCellSelected ? self.themeInfo.secondaryColor.cgColor : UIColor.colorE5E5E5.cgColor
            self.nameTeamLabel.textColor = self.isCellSelected ? .colorBlack111111 : .colorB8B8B8
        }
    }
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure<T>(data: T) {
        if let team = data as? SportInfo {
            self.nameTeamLabel.text = team.name.message
        }
    }
    
}
