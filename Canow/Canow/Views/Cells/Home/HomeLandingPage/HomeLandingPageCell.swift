//
//  HomeLandingPageCell.swift
//  Canow
//
//  Created by Trần Lễ on 2/7/22.
//

import UIKit

class HomeLandingPageCell: BaseTableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var newsImageView: UIImageView! {
        didSet {
            self.newsImageView.layer.cornerRadius = 7
        }
    }
    @IBOutlet weak var nameNewsLabel: UILabel! {
        didSet {
            self.nameNewsLabel.font = .font(with: .medium500, size: 16)
            self.nameNewsLabel.textColor = .black
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.font = .font(with: .light300, size: 14)
            self.dateLabel.textColor = .color646464
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure<T>(data: T) {
        if let data = data as? NewsInfo {
            if let imageUrl = CommonManager.getImageURL(data.image) {
                self.newsImageView.kf.setImage(with: imageUrl)
            }
            nameNewsLabel.text = data.name
            dateLabel.text = self.convertDateToString(stringDate: data.availableFrom)
        }
    }
    
    private func convertDateToString(stringDate: String?) -> String {
        if let date: Date = stringDate?.toDate(dateFormat: DateFormat.DATE_CURRENT) {
            let string: String = date.toString(dateFormat: DateFormat.DATE_FORMAT_DEFAULT)
            return string
        }
        return ""
    }
    
}
