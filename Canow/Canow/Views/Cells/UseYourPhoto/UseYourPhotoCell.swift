//
//  UseYourPhotoCell.swift
//  Canow
//
//  Created by TuanBM6 on 12/20/21.
//

import UIKit
import Photos

class UseYourPhotoCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var iconSelectImage: UIImageView!
    
    // MARK: - Override methods
    override var isSelected: Bool {
        didSet {
            self.selectedView.isHidden = !self.isSelected
            self.iconSelectImage.isHidden = !self.isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Life cycle
    override func configure<T>(data: T) {
        guard let asset = data as? PHAsset else {
            return
        }
        let manager = PHImageManager.default()
        var imageRequestOptions: PHImageRequestOptions {
            let options = PHImageRequestOptions()
            options.version = .current
            options.resizeMode = .exact
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.isSynchronous = true
            return options
        }
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: imageRequestOptions) { image, _ in
            DispatchQueue.main.async {
                self.photoImageView.image = image
            }
        }
    }
    
}
