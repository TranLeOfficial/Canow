//
//  ContactResultTableViewCell.swift
//  Canow
//
//  Created by NhiVHY on 1/5/22.
//

import UIKit

class ContactResultCell: BaseTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImage: UIImageView! {
        didSet {
            self.avatarImage.rounded()
        }
    }
    
    @IBOutlet private weak var statusView: UIView! {
        didSet {
            self.statusView.isHidden = true
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            self.nameLabel.font = .font(with: .bold700, size: 14)
        }
    }
    
    @IBOutlet private weak var phoneLabel: UILabel! {
        didSet {
            self.phoneLabel.font = .font(with: .medium500, size: 12)
            self.phoneLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet private weak var inactiveLabel: UILabel! {
        didSet {
            self.inactiveLabel.font = .font(with: .medium500, size: 14)
            self.inactiveLabel.textColor = .colorRedEB2727
            self.inactiveLabel.text = StringConstants.s12LbReceiverInactive.localized
            self.inactiveLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet private weak var transferYourselfLabel: UILabel! {
        didSet {
            self.transferYourselfLabel.text = StringConstants.s05MessageTransferToYourself.localized
            self.transferYourselfLabel.font = .font(with: .medium500, size: 14)
            self.transferYourselfLabel.textColor = .colorRedEB2727
        }
    }
    @IBOutlet private weak var infoView: UIView!
    
    override func configure<T>(data: T) {
        if let receiverInfo = data as? ReceiverTransferInfo {
            self.avatarImage.kf.setImage(with: CommonManager.getImageURL(receiverInfo.avatar),
                                         placeholder: UIImage(named: "ic_avatar"))
            self.nameLabel.text = receiverInfo.name
            self.phoneLabel.text = receiverInfo.phone
            self.statusView.isHidden = receiverInfo.status == "Active"
        }
    }
    
}

extension ContactResultCell {
    func updateUI<T>(data: T) {
        if let receiverInfo = data as? ReceiverTransferInfo {
            if receiverInfo.phone == DataManager.shared.getCustomerInfo()?.userName {
                self.transferYourselfLabel.isHidden = false
                self.infoView.alpha = 0.5
                self.isUserInteractionEnabled = false
            } else {
                self.transferYourselfLabel.isHidden = true
                self.infoView.alpha = 1
                self.isUserInteractionEnabled = true
            }
        }
    }
}
