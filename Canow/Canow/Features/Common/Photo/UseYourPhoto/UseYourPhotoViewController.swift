//
//  UseYourPhotoViewController.swift
//  Canow
//
//  Created by TuanBM6 on 12/20/21.
//

import UIKit
import Photos

class UseYourPhotoViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var yourPhotoCollectionView: UICollectionView! {
        didSet {
            self.yourPhotoCollectionView.registerReusedCell(cellNib: UseYourPhotoCell.self, bundle: nil)
            self.yourPhotoCollectionView.delegate = self
            self.yourPhotoCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet private weak var cameraRollLabel: UILabel! {
        didSet {
            self.cameraRollLabel.text = StringConstants.s01TitleCameraRoll.localized
            self.cameraRollLabel.font = .font(with: .bold700, size: 16)
            self.cameraRollLabel.textColor = .colorBlack111111
        }
    }
    @IBOutlet weak var cameraRollImageView: UIImageView!
    
    @IBOutlet private weak var selectPhotoButton: CustomButton! {
        didSet {
            self.selectPhotoButton.setTitle(StringConstants.s01BtnSelectPhoto.localized, for: .normal)
            self.selectPhotoButton.setTitle(StringConstants.s01BtnSelectPhoto.localized, for: .highlighted)
            self.selectPhotoButton.disable()
        }
    }
    
    // MARK: - Properties
    var assets = PHFetchResult<PHAsset>()
    private var themeInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    var onSelectPhoto: (UIImage, String) -> Void = { _, _ in }
    private var images = [PHAsset]()
    private var imageSelected: Int?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func updateTheme() {
        self.backButton.imageView?.setImageColor(self.themeInfo.textColor)
        self.cameraRollLabel.textColor = self.themeInfo.textColor
        self.cameraRollImageView.setImageColor(self.themeInfo.textColor)
    }
    
}

// MARK: - Methods
extension UseYourPhotoViewController {
    
    private func setupUI() {
        self.assets.enumerateObjects { (object,_,_) in
            self.images.append(object)
            self.yourPhotoCollectionView.reloadData()
        }
    }
    
}

// MARK: - Actions
extension UseYourPhotoViewController {
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        guard let index = self.imageSelected else { return }
        let asset = self.images[index]
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
        manager.requestImage(for: asset,
                                targetSize: PHImageManagerMaximumSize,
                                contentMode: .aspectFit,
                                options: imageRequestOptions) { image, _ in
            DispatchQueue.main.async {
                guard let image = image else {
                    return
                }
                let assetResources = PHAssetResource.assetResources(for: asset)
                if let fileName = assetResources.first?.originalFilename {
                    let previewPhotoVC = PreviewPhotoViewController(image: image, fileName: fileName)
                    previewPhotoVC.delegate = self
                    self.present(viewController: previewPhotoVC)
                }
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.pop()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension UseYourPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellNib: UseYourPhotoCell.self, indexPath: indexPath)
        cell?.configure(data: self.images[indexPath.row])
        return cell ?? BaseCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageSelected = indexPath.row
        self.selectPhotoButton.enable()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 6) / 3
        return CGSize(width: width, height: width)
    }
    
}

// MARK: - PreviewPhotoDelegate
extension UseYourPhotoViewController: PreviewPhotoDelegate {
    
    func onSave(image: UIImage, fileName: String) {
        self.onSelectPhoto(image, fileName)
        self.pop(animated: false)
    }
    
}
