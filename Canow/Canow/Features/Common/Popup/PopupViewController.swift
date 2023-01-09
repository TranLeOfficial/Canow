//
//  PopupViewController.swift
//  Canow
//
//  Created by hieplh2 on 09/12/2021.
//

import UIKit

class PopupViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: CustomButton! {
        didSet {
            self.rightButton.setupUI()
        }
    }
    
    // MARK: - Properties
    private var popupTitle = ""
    private var popupMessage: String?
    
    private var popupBg: UIImage?
    
    private var titleFont: UIFont
    private var messageFont: UIFont
    
    private var leftButtonTitle: String?
    private var leftButtonAction: (() -> Void)?
    
    private var rightButtonTitle = ""
    private var rightButtonAction: () -> Void = {}
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Constructors
    init(title: String,
         message: String? = nil,
         popupBg: UIImage?,
         titleFont: UIFont,
         messageFont: UIFont,
         leftButton: AlertButton? = nil,
         rightButton: AlertButton) {
        self.popupTitle = title
        self.popupMessage = message
        
        self.popupBg = popupBg
        
        self.titleFont = titleFont
        self.messageFont = messageFont
        
        self.leftButtonTitle = leftButton?.title
        self.leftButtonAction = leftButton?.action
        
        self.rightButtonTitle = rightButton.title
        self.rightButtonAction = rightButton.action
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods
extension PopupViewController {
    
    private func setupUI() {
        self.titleLabel.text = self.popupTitle
        self.messageLabel.text = self.popupMessage
        
        self.backgroundImageView.image = self.popupBg
        
        self.titleLabel.font = self.titleFont
        self.messageLabel.font = self.messageFont
        
        self.rightButton.setTitle(self.rightButtonTitle, for: .normal)
        self.rightButton.setTitle(self.rightButtonTitle, for: .highlighted)
        self.rightButton.setupUI()
        
        self.leftButton.isHidden = self.leftButtonTitle == nil
        self.leftButton.setTitle(self.leftButtonTitle, for: .normal)
        self.leftButton.setTitle(self.leftButtonTitle, for: .highlighted)
    }
    
}

// MARK: - Actions
extension PopupViewController {
    
    @IBAction func actionLeftButton(_ sender: Any) {
        if let action = self.leftButtonAction {
            action()
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func actionRightButton(_ sender: Any) {
        self.rightButtonAction()
        self.dismiss(animated: true)
    }
    
}
