//
//  PreviewPhotoViewController.swift
//  Canow
//
//  Created by hieplh2 on 23/12/2021.
//

import UIKit

enum PreviewMode {
    case photo, camera
}

protocol PreviewPhotoDelegate: AnyObject {
    func onSave(image: UIImage, fileName: String)
}

class PreviewPhotoViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = self.image
        }
    }
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            self.cancelButton.setTitle(StringConstants.s01BtnCancel.localized, for: .normal)
            self.cancelButton.setTitle(StringConstants.s01BtnCancel.localized, for: .highlighted)
            self.cancelButton.titleLabel?.font = .font(with: .medium500, size: 16)
            self.cancelButton.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            self.saveButton.setTitle(StringConstants.s07BtnSave.localized, for: .normal)
            self.saveButton.setTitle(StringConstants.s07BtnSave.localized, for: .highlighted)
            self.saveButton.titleLabel?.font = .font(with: .medium500, size: 16)
            self.saveButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Properties
    weak var delegate: PreviewPhotoDelegate?
    
    var image: UIImage
    var fileName: String
    var onCancel: () -> Void = {}
    var mode: PreviewMode = .photo
    
    // MARK: - Constructors
    init(image: UIImage, fileName: String) {
        self.image = image
        self.fileName = fileName
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

}

// MARK: - Methods
extension PreviewPhotoViewController {
    
    private func setupUI() {
        let avatarHoleY = (self.imageView.frame.height / 2) - (ScreenSize.screenWidth / 2)
        let avatarHoleFrame = CGRect(x: 0, y: avatarHoleY, width: ScreenSize.screenWidth, height: ScreenSize.screenWidth)
        let hole = [TACircularSubtractionPath(frame: avatarHoleFrame, radius: ScreenSize.screenWidth / 2)]
        let overlayView = TAOverlayView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: ScreenSize.screenWidth,
                                                      height: ScreenSize.screenHeight),
                                        subtractedPaths: hole)
        self.contentView.addSubview(overlayView)
    }
    
}

// MARK: - Actions
extension PreviewPhotoViewController {
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: self.mode == .photo)
        self.onCancel()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.onSave(image: self.image, fileName: self.fileName)
    }
    
}
