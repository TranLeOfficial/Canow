//
//  RemittanceItemCell.swift
//  Canow
//
//  Created by TuanBM6 on 12/7/21.
//

import UIKit
import Kingfisher

class RemittanceItemCell: BaseCollectionViewCell {
    
    @IBOutlet weak var remittantItemImage: UIImageView! {
        didSet {
            self.remittantItemImage.rounded()
        }
    }
    @IBOutlet weak var remittantItemName: UILabel! {
        didSet {
            self.remittantItemName.textColor = .color646464
            self.remittantItemName.font = .font(with: .medium500, size: 12)
        }
    }
    @IBOutlet weak var remittantItemPrice: UILabel! {
        didSet {
            self.remittantItemPrice.font = .font(with: .bold700, size: 14)
            self.remittantItemPrice.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var background: UIView!
    var isCellSelected: Bool = false {
        didSet {
            self.background.clipsToBounds = true
            self.background.layer.cornerRadius = 10
            self.background.layer.borderWidth = 1
            self.background.layer.borderColor = self.isCellSelected ? UIColor.colorBlack111111.cgColor : UIColor.colorB8B8B8.cgColor
            self.imageButtonRadio.image = self.isCellSelected ? UIImage(named: "ic_radio_select") : UIImage(named: "ic_radio_unselect")
        }
    }
    @IBOutlet weak var imageButtonRadio: UIImageView! {
        didSet {
            self.imageButtonRadio.image = UIImage(named: "ic_radio_unselect")
            self.imageButtonRadio.layer.cornerRadius = self.imageButtonRadio.frame.size.width / 2
        }
    }
    @IBOutlet weak var iconImage: UIImageView! {
        didSet {
            self.iconImage.image = UIImage(named: "")
            self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width / 2
        }
    }
    
    // MARK: - Properties
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configure<T>(data: T) {
        guard let remittance = data as? RemittanceItemInfo else { return }
        self.remittantItemName.text = remittance.name
        self.remittantItemPrice.text = "\(remittance.price ?? 0)".formatPrice()
        if let remittanceImage = CommonManager.getImageURL(remittance.icon ?? "") {
            self.remittantItemImage.kf.setImage(with: remittanceImage)
        }
    }
    
    func configureImage(urlImage: String) {
        self.iconImage.kf.setImage(with: CommonManager.getImageURL(urlImage))
    }
}
