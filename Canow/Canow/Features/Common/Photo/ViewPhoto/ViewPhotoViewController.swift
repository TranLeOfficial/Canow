//
//  ViewPhotoViewController.swift
//  Canow
//
//  Created by hieplh2 on 23/12/2021.
//

import UIKit

class ViewPhotoViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
}

// MARK: - Methods
extension ViewPhotoViewController {
    
    private func setupUI() {
        self.imageView.image = self.image
    }
    
}

// MARK: - Actions
extension ViewPhotoViewController {

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
