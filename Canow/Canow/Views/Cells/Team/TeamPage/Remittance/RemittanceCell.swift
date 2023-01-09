//
//  RemittanceCell.swift
//  Canow
//
//  Created by TuanBM6 on 10/29/21.
//

import UIKit
import Kingfisher

class RemittanceCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var campaignCollectionView: UICollectionView! {
        didSet {
            self.campaignCollectionView.registerReusedCell(cellNib: CampaignCollectionViewCell.self, bundle: nil)
            self.campaignCollectionView.delegate = self
            self.campaignCollectionView.dataSource = self
        }
    }
    @IBOutlet private weak var remImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dayLeftLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var totalBackerLabel: UILabel!
    @IBOutlet private weak var remLogo: UIImageView!
    @IBOutlet private weak var cardView: UIView!
    
    // MARK: - Properties
    var campaignArray = [CampaignItem]()
    
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
extension RemittanceCell {
    private func setupUI() {
        cardView.dropShadow()
    }
    
    func configure(data: RemittanceInfo) {
        campaignArray = [CampaignItem]()
        nameLabel.text = data.name
        dayLeftLabel.text = "\(data.daysLeft) Days left"
        totalAmountLabel.text = "Total Amount \(data.totalAmount)"
        totalBackerLabel.text = "Total Backer \(data.totalBacker)"
        for item in data.listCampaignItem {
            campaignArray.append(item)
        }
        if let remUrl = CommonManager.getImageURL(data.image), let remLogoUrl = CommonManager.getImageURL(data.fantokenLogo) {
            self.remImageView.kf.setImage(with: remUrl)
            self.remLogo.kf.setImage(with: remLogoUrl)
        }
        campaignCollectionView.reloadData()
    }
}

extension RemittanceCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaignArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellNib: CampaignCollectionViewCell.self, indexPath: indexPath)
        cell?.configure(campaignItem: campaignArray[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 80)
    }
}
