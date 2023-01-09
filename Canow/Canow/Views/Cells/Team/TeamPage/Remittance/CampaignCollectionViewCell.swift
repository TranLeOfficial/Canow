//
//  CampaignCollectionViewCell.swift
//  Canow
//
//  Created by TuanBM6 on 11/2/21.
//

import UIKit
import Kingfisher

class CampaignCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var campaignImage: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension CampaignCollectionViewCell {
    func configure(campaignItem: CampaignItem) {
        if let campaignUrl = CommonManager.getImageURL(campaignItem.icon) {
            self.campaignImage.kf.setImage(with: campaignUrl)
        }
        priceLabel.text = campaignItem.quantity
    }
}
