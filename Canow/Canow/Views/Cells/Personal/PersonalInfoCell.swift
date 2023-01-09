//
//  PersonalInfoCell.swift
//  Canow
//
//  Created by hieplh2 on 08/12/2021.
//

import UIKit

class PersonalInfoCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            self.avatarImageView.rounded()
        }
    }
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var editProfileButton: CustomButton! {
        didSet {
            self.editProfileButton.titleLabel?.textColor = .colorBlack111111
            self.editProfileButton.titleLabel?.font = .font(with: .bold700, size: 16)
        }
    }
    // MARK: - Properties
    var goToEditProfile: () -> Void = {}
    var showChooseImage: () -> Void = {}
    var showAvatar: (UIImage?) -> Void = { _ in }
    var onSetImage: (UIImage?) -> Void = { _ in }
    
    override func configure<T>(data: T) {
        guard let data = data as? (isLogin: Bool, image: UIImage?, avatar: String?, name: String?, phone: String?) else { return }
        
        let themeInfo = DataManager.shared.getTheme()
        if themeInfo.bgPattern2 != nil {
            self.backgroundColor = .clear
            self.nameLabel.textColor = themeInfo.textColor
            self.phoneLabel.textColor = themeInfo.textColor
        } else {
            self.backgroundColor = .white
            self.nameLabel.textColor = .colorBlack111111
            self.phoneLabel.textColor = .color646464
        }
        self.editProfileButton.setupUI()
        
        if data.isLogin {
            if let image = data.image {
                self.avatarImageView.image = image
            } else if let avatar = data.avatar {
                self.avatarImageView.kf.setImage(with: CommonManager.getImageURL(avatar), placeholder: UIImage(named: "ic_avatar"))
            } else {
                self.avatarImageView.image = UIImage(named: "ic_avatar")
            }
            self.cameraButton.isHidden = false
            self.nameLabel.text = data.name
            self.phoneLabel.text = data.phone
            
            self.editProfileButton.setTitle(StringConstants.s07EditProfile.localized, for: .normal)
            self.editProfileButton.setTitle(StringConstants.s07EditProfile.localized, for: .highlighted)
            
            self.onSetImage(self.avatarImageView.image)
            self.avatarImageView.isUserInteractionEnabled = true
            self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewAvatar)))
        } else {
            self.avatarImageView.image = UIImage(named: "ic_avatar")
            self.cameraButton.isHidden = true
            self.nameLabel.text = StringConstants.s07LbGuest.localized
            self.phoneLabel.text = nil
            
            self.editProfileButton.setTitle(StringConstants.s01BtnLogin.localized, for: .normal)
            self.editProfileButton.setTitle(StringConstants.s01BtnLogin.localized, for: .highlighted)
            
            self.avatarImageView.isUserInteractionEnabled = false
        }
    }
    
}

// MARK: - Actions
extension PersonalInfoCell {
    
    @IBAction func actionCamera(_ sender: Any) {
        self.showChooseImage()
    }
    
    @IBAction func actionEditProfile(_ sender: Any) {
        self.goToEditProfile()
    }
    
    @objc func viewAvatar() {
        self.showAvatar(self.avatarImageView.image)
    }
    
}
