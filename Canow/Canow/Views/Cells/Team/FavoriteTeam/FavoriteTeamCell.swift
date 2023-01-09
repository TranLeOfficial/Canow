//
//  FavoriteTeamCell.swift
//  Canow
//
//  Created by hieplh2 on 10/12/2021.
//

import UIKit
import Kingfisher

class FavoriteTeamCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel! {
        didSet {
            self.teamNameLabel.font = .font(with: .bold700, size: 12)
        }
    }
    @IBOutlet weak var teamView: UIView! {
        didSet {
            self.teamView.clipsToBounds = true
            self.teamView.layer.cornerRadius = 6
            self.teamView.layer.borderColor = UIColor.colorE5E5E5.cgColor
            self.teamView.layer.borderWidth = 1
        }
    }
    override var isSelected: Bool {
        didSet {
            if self.favoriteTeamType == .fanToken {
                self.teamImageView.image = self.logoImage
            } else {
                self.teamView.layer.borderColor = self.isSelected ? UIColor.colorBlack111111.cgColor : UIColor.colorE5E5E5.cgColor
                self.teamImageView.image = self.isSelected ? self.logoImage : self.logoImage?.grayScaled
            }
        }
    }
    private var logoImage: UIImage?
    private var favoriteTeamType: FavoriteTeamType?
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure<T>(data: T) {
        guard let favorite = data as? (parnerInfo: PartnerSportInfo, favoriteTeamType: FavoriteTeamType) else {
            return
        }
        self.teamNameLabel.text = favorite.parnerInfo.partnerName
        self.favoriteTeamType = favorite.favoriteTeamType
        if let teamImage = CommonManager.getImageURL(favorite.parnerInfo.avatar) {
            let resource = ImageResource(downloadURL: teamImage)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.logoImage = value.image
                    if self.favoriteTeamType == .fanToken {
                        self.teamImageView.image = self.logoImage
                    } else {
                        self.teamImageView.image = self.isSelected ? self.logoImage : self.logoImage?.grayScaled
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
}
