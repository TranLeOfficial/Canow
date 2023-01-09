//
//  HomeRemittanceTableViewCell.swift
//  Canow
//
//  Created by PhucNT34 on 1/13/22.
//

import UIKit
import Kingfisher
import Localize

class HomeRemittanceTableViewCell: BaseTableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var homeRemittanceView: UIView! {
        didSet {
            self.homeRemittanceView.layer.cornerRadius = 6
            self.homeRemittanceView.dropShadow()
        }
    }
    @IBOutlet private weak var avatartView: UIView! {
        didSet {
            self.avatartView.layer.cornerRadius = self.avatartView.frame.height/2
            self.avatartView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var remittancedForPersonLabel: UILabel! {
        didSet {
            self.remittancedForPersonLabel.font = .font(with: .bold700, size: 14)
            self.remittancedForPersonLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var dueDateLabel: UILabel! {
        didSet {
            self.dueDateLabel.font = .font(with: .medium500, size: 12)
            self.dueDateLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var leftView: UIView! {
        didSet {
            self.leftView.layer.cornerRadius = self.leftView.frame.height/2
            self.leftView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var iconLeftImageView: UIImageView!
    @IBOutlet private weak var leftLabel: UILabel! {
        didSet {
            self.leftLabel.font = .font(with: .medium500, size: 12)
            self.leftLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var midView: UIView! {
        didSet {
            self.midView.layer.cornerRadius = self.midView.frame.height/2
            self.midView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var iconMidImageView: UIImageView!
    @IBOutlet private weak var midLabel: UILabel! {
        didSet {
            self.midLabel.font = .font(with: .medium500, size: 12)
            self.midLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var rightView: UIView! {
        didSet {
            self.rightView.layer.cornerRadius = self.rightView.frame.height/2
            self.rightView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var iconRightImageView: UIImageView!
    @IBOutlet private weak var rightLabel: UILabel! {
        didSet {
            self.rightLabel.font = .font(with: .medium500, size: 12)
            self.rightLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var boderView: UIView! {
        didSet {
            self.boderView.backgroundColor = .colorE5E5E5
        }
    }
    @IBOutlet private weak var iconDonateView: UIView! {
        didSet {
            self.iconDonateView.rounded()
            self.iconDonateView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var iconDonateImageView: UIImageView!
    @IBOutlet private weak var priceDonateLabel: UILabel! {
        didSet {
            self.priceDonateLabel.font = .font(with: .black900, size: 20)
            self.priceDonateLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var donateLabel: UILabel! {
        didSet {
            self.donateLabel.text = StringConstants.s10lbDonated.localized
            self.donateLabel.font = .font(with: .bold700, size: 12)
            self.donateLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var backersLabel: UILabel! {
        didSet {
            self.backersLabel.text = StringConstants.s10LbBacker.localized
            self.backersLabel.font = .font(with: .medium500, size: 12)
            self.backersLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet private weak var quantityBackersLabel: UILabel! {
        didSet {
            self.quantityBackersLabel.font = .font(with: .bold700, size: 12)
            self.quantityBackersLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var donateEnglishLabel: UILabel! {
        didSet {
            self.donateEnglishLabel.text = StringConstants.s10lbDonated.localized
            self.donateEnglishLabel.font = .font(with: .bold700, size: 12)
            self.donateEnglishLabel.textColor = .colorB8B8B8
        }
    }
    @IBOutlet weak var backersEnglishLabel: UILabel! {
        didSet {
            self.backersEnglishLabel.text = StringConstants.s10LbBacker.localized
            self.backersEnglishLabel.font = .font(with: .medium500, size: 12)
            self.backersEnglishLabel.textColor = .colorB8B8B8
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.changeIndexText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeIndexText() {
        if CommonManager.checkLanguageJP {
            self.backersEnglishLabel.isHidden = false
            self.backersLabel.isHidden = true
            self.donateEnglishLabel.isHidden = true
            self.donateLabel.isHidden = false
        } else {
            self.backersEnglishLabel.isHidden = true
            self.backersLabel.isHidden = false
            self.donateEnglishLabel.isHidden = false
            self.donateLabel.isHidden = true
        }
    }
    
    override func configure<T>(data: T) {
        if let remittance = data as? RemittanceInfo {
            
            let campaignImageViewGroup: [UIImageView] = [self.iconLeftImageView, self.iconMidImageView, self.iconRightImageView]
            let campaignLabelGroup: [UILabel] = [self.leftLabel, self.midLabel, self.rightLabel]
            
            self.avatarImageView.kf.setImage(with: CommonManager.getImageURL(remittance.image))
            self.remittancedForPersonLabel.text = remittance.name
            self.priceDonateLabel.text = remittance.totalAmount.formatPrice()
            self.iconDonateImageView.kf.setImage(with: CommonManager.getImageURL(remittance.fantokenLogo))
            self.quantityBackersLabel.text = remittance.totalBacker.formatPrice()
            self.dueDateLabel.text = "\(StringConstants.dueDate.localized): \(self.convertDateToString(stringDate: remittance.availableTo))"
            
            for (index, imageView) in campaignImageViewGroup.enumerated() where imageView.tag == index {
                imageView.kf.setImage(with: CommonManager.getImageURL(remittance.listCampaignItem[index].icon))
            }
            for (index, label) in campaignLabelGroup.enumerated() where label.tag == index {
                label.text = remittance.listCampaignItem[index].quantity
            }
        }
    }
    
    private func convertDateToString(stringDate: String?) -> String {
        if let date: Date = stringDate?.toDate(dateFormat: DateFormat.DATE_CURRENT) {
            let string: String = date.toString(dateFormat: DateFormat.DATE_FORMAT_CROWDFUNDING)
            return string
        }
        return ""
    }
    
}
