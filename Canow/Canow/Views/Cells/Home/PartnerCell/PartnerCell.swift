//
//  TeamCell.swift
//  Canow
//
//  Created by TuanBM6 on 10/19/21.
//

import UIKit
import Kingfisher

class PartnerCell: UICollectionViewCell {

    @IBOutlet weak var tickerLable: UILabel!
    @IBOutlet weak var partnerAvatarImageView: UIImageView!
    @IBOutlet weak var partnerNameLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(_ partnerInfo: PartnerInfo) {
        self.tickerLable.text = partnerInfo.ticker
        if partnerInfo.fantokenBalance != nil {
            self.tickerLable.text = "\(partnerInfo.fantokenBalance ?? 0) \(partnerInfo.ticker)"
        }
        self.partnerNameLable.text = partnerInfo.partnerName
        let urlImage = partnerInfo.avatar
        if let url = CommonManager.getImageURL(urlImage) {
            self.partnerAvatarImageView.kf.setImage(with: url)
        }
    }

}
