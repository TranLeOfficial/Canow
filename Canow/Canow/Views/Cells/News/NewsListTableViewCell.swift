//
//  NewsListTableViewCell.swift
//  Canow
//
//  Created by PhuNT14 on 16/11/2021.
//

import UIKit
import Kingfisher

class NewsListTableViewCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viewContent: UIView! {
        didSet {
            self.viewContent.layer.cornerRadius = 7
            self.viewContent.dropShadow()
            self.viewContent.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            self.nameLabel.textColor = .colorBlack111111
            self.nameLabel.font = .font(with: .bold700, size: 15)
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.textColor = .color646464
            self.dateLabel.font = .font(with: .medium500, size: 12)
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Override Methods
    override func configure<T>(data: T) {
        if let data = data as? NewsInfo {
            self.imgView.kf.setImage(with: CommonManager.getImageURL(data.image))
            nameLabel.text = data.name
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
