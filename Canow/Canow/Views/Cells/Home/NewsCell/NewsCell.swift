//
//  NewsCell.swift
//  Canow
//
//  Created by TuanBM6 on 10/19/21.
//

import UIKit
import Kingfisher

class NewsCell: UICollectionViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configView(_ newsInfo: NewsInfo) {
        self.nameLable.text = newsInfo.name
        let image = newsInfo.image
        if let imageUrl = CommonManager.getImageURL(image) {
            self.newsImage.kf.setImage(with: imageUrl)
        }
    }

}
