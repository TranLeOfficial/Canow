//
//  HomeCrowdfundingTableViewCell.swift
//  Canow
//
//  Created by PhucNT34 on 1/13/22.
//

import UIKit
import Kingfisher

class HomeCrowdfundingTableViewCell: BaseTableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var homeCrowdfundingView: UIView! {
        didSet {
            self.homeCrowdfundingView.layer.cornerRadius = 6
            self.homeCrowdfundingView.dropShadow()
        }
    }
    @IBOutlet private weak var gradientImageView: UIImageView! {
        didSet {
            self.gradientImageView.image = UIImage(named: "bg_cf_image_gradient")
        }
    }
    @IBOutlet private weak var bannerImageView: UIImageView! {
        didSet {
            self.bannerImageView.layer.cornerRadius = 6
            self.bannerImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet private weak var successView: UIView! {
        didSet {
            self.successView.backgroundColor = .colorYellowFFCC00
            self.successView.layer.cornerRadius = 16
            self.successView.isHidden = true
        }
    }
    @IBOutlet private weak var successLabel: UILabel! {
        didSet {
            self.successLabel.text = StringConstants.s17LbSuccess.localized
            self.successLabel.font = .font(with: .bold700, size: 12)
            self.successLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var iconSuccessView: UIView! {
        didSet {
            self.iconSuccessView.backgroundColor = .clear
        }
    }
    @IBOutlet private weak var successImageView: UIImageView! {
        didSet {
            self.successImageView.image = UIImage(named: "ic_crowdfundingSuccess")
        }
    }
    @IBOutlet private weak var closedView: UIView! {
        didSet {
            self.closedView.backgroundColor = .colorB8B8B8
            self.closedView.layer.cornerRadius = 16
            self.closedView.isHidden = true
        }
    }
    @IBOutlet private weak var closedLabel: UILabel! {
        didSet {
            self.closedLabel.text = StringConstants.s17LbClosed.localized
            self.closedLabel.font = .font(with: .bold700, size: 12)
            self.closedLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.textColor = .white
            self.titleLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet private weak var contentLabel: UILabel! {
        didSet {
            self.contentLabel.textColor = .colorBlack111111
            self.contentLabel.font = .font(with: .regular400, size: 12)
        }
    }
    @IBOutlet weak var boderStackView: UIStackView! {
        didSet {
            self.boderStackView.backgroundColor = .colorE5E5E5
        }
    }
    @IBOutlet private weak var targetQuantityLabel: UILabel! {
        didSet {
            self.targetQuantityLabel.textColor = .colorBlack111111
            self.targetQuantityLabel.font = .font(with: .black900, size: 20)
        }
    }
    @IBOutlet private weak var iconTargetView: UIView! {
        didSet {
            self.iconTargetView.layer.cornerRadius = self.iconTargetView.frame.height/2
            self.iconTargetView.clipsToBounds = true
            self.iconTargetView.backgroundColor = .color1E237B
        }
    }
    @IBOutlet private weak var targetImageView: UIImageView! {
        didSet {
            self.targetImageView.image = UIImage(named: "ic_team")
        }
    }
    @IBOutlet private weak var targetLabel: UILabel! {
        didSet {
            self.targetLabel.text = StringConstants.s17LbTarget.localized
            self.targetLabel.textColor = .colorB8B8B8
            self.targetLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var raisedQuantityLabel: UILabel! {
        didSet {
            self.raisedQuantityLabel.textColor = .colorBlack111111
            self.raisedQuantityLabel.font = .font(with: .black900, size: 20)
        }
    }
    @IBOutlet private weak var iconRaisedView: UIView! {
        didSet {
            self.iconRaisedView.layer.cornerRadius = self.iconRaisedView.frame.height/2
            self.iconRaisedView.clipsToBounds = true
            self.iconRaisedView.backgroundColor = .color1E237B
        }
    }
    @IBOutlet private weak var raisedImageView: UIImageView! {
        didSet {
            self.raisedImageView.image = UIImage(named: "ic_team")
        }
    }
    @IBOutlet private weak var raisedLabel: UILabel! {
        didSet {
            self.raisedLabel.text = StringConstants.s17LbRaised.localized
            self.raisedLabel.textColor = .colorB8B8B8
            self.raisedLabel.font = .font(with: .medium500, size: 14)
        }
    }
    @IBOutlet private weak var progessView: ProgressView!
    @IBOutlet private weak var dueDateLabel: UILabel! {
        didSet {
            self.dueDateLabel.text = StringConstants.s17LbDueDate.localized
            self.dueDateLabel.textColor = .color646464
            self.dueDateLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            self.dateLabel.textColor = .colorBlack111111
            self.dateLabel.font = .font(with: .bold700, size: 14)
        }
    }
    @IBOutlet private weak var backersLabel: UILabel! {
        didSet {
            self.backersLabel.text = StringConstants.s17LbBackers.localized
            self.backersLabel.textColor = .color646464
            self.backersLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var backersJPLanguageLabel: UILabel! {
        didSet {
            self.backersJPLanguageLabel.text = StringConstants.s17LbBackers.localized
            self.backersJPLanguageLabel.textColor = .color646464
            self.backersJPLanguageLabel.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet private weak var backersQuantityLabel: UILabel! {
        didSet {
            self.backersQuantityLabel.textColor = .colorBlack111111
            self.backersQuantityLabel.font = .font(with: .bold700, size: 14)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func configure<T>(data: T) {
        if let crowdfunding = data as? CrowdfundingInfo {
            self.bannerImageView.kf.setImage(with: CommonManager.getImageURL(crowdfunding.image))
            self.titleLabel.text = crowdfunding.name
            self.contentLabel.text = crowdfunding.description?.htmlToString
            self.targetImageView.kf.setImage(with: CommonManager.getImageURL(crowdfunding.fantokenLogo))
            self.targetQuantityLabel.text = crowdfunding.targetAmount?.formatPrice()
            self.raisedImageView.kf.setImage(with: CommonManager.getImageURL(crowdfunding.fantokenLogo))
            self.raisedQuantityLabel.text = crowdfunding.currentReceivedAmount?.formatPrice()
            self.dateLabel.text = convertDateToString(stringDate: crowdfunding.availableTo)
            self.backersQuantityLabel.text = crowdfunding.totalBacker?.formatPrice()
            self.backersJPLanguageLabel.isHidden = !CommonManager.checkLanguageJP
            self.backersLabel.isHidden = CommonManager.checkLanguageJP
            
            if let targetAmount = Double(crowdfunding.targetAmount ?? ""),
                let currentReceivedAmount = Double(crowdfunding.currentReceivedAmount ?? "") {
                self.progessView.current = currentReceivedAmount
                self.progessView.total = targetAmount
            }

            switch crowdfunding.status {
            case .inProgress:
                self.closedView.isHidden = true
            case .closed:
                self.closedView.isHidden = false
            }
            if let currentReceivedAmount = Float(crowdfunding.currentReceivedAmount ?? ""), let raised = Float(crowdfunding.targetAmount ?? "") {
                if (currentReceivedAmount / raised) >= 1 {
                    self.successView.isHidden = false
                } else {
                    self.successView.isHidden = true
                }
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
