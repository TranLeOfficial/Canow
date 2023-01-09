//
//  CrowdfundingCell.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import UIKit

class CrowdfundingCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var cfImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var currentAmountLabel: UILabel!
    @IBOutlet private weak var cfLogo: UIImageView!
    @IBOutlet private weak var progressView: ProgressView!
    @IBOutlet private weak var backerLabel: UILabel!
    @IBOutlet private weak var dayLeftLabel: UILabel!
    @IBOutlet private weak var closedLabel: UILabel!
    @IBOutlet private weak var cardView: UIView!
    
    // MARK: - Construction
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: - Methods
extension CrowdfundingCell {
    private func setupUI() {
        cardView.dropShadow()
    }
    
    func configure(data: CrowdfundingInfo) {
        nameLabel.text = data.name
        descriptionLabel.text = data.description?.htmlToString
        currentAmountLabel.text = "\(data.currentReceivedAmount ?? "0") Raised"
        backerLabel.text = "\(data.totalBacker ?? "0") Backers"
        dayLeftLabel.text = "\(data.daysLeft ?? 0) Days left"
        if let cfImageURL = CommonManager.getImageURL(data.image), let cfLogoURL = CommonManager.getImageURL(data.fantokenLogo) {
            self.cfImage.kf.setImage(with: cfImageURL)
            self.cfLogo.kf.setImage(with: cfLogoURL)
        }
        if let current = Double(data.currentReceivedAmount ?? ""), let target = Double(data.targetAmount ?? "") {
            self.progressView.current = current
            self.progressView.total = target
        }
        closedLabel.isHidden = data.status == .closed ? false : true
    }
    
}
