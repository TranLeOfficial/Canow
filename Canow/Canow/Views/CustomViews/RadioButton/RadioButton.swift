//
//  RadioButton.swift
//  Canow
//
//  Created by TuanBM6 on 10/11/21.
//

import UIKit

protocol RadioButtonDelegate: AnyObject {
    func onClick(_ sender: RadioButton)
}

class RadioButton: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            self.titleLabel.textColor = UIColor(hexString: "#B0B0B0")
        }
    }
    @IBOutlet weak var radioButton: UIButton!
    var isEnabled: Bool = true {
        didSet {
            self.radioButton.isEnabled = isEnabled
        }
    }
    var titleFont: UIFont = .font(with: .regular400, size: 12)
    weak var delegate: RadioButtonDelegate?
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
}

// MARK: - Methods
extension RadioButton {
    
    private func setupView() {
        Bundle.main.loadNibNamed("RadioButton", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.titleLabel.font = titleFont
    }

}

// MARK: - Public properties
extension RadioButton {
    
    @IBInspectable
    public var selected: Bool {
        get {
            return self.imageView.image == UIImage(named: "ic_radio_selected")
        }
        set {
            self.imageView.image = newValue ? UIImage(named: "ic_radio_selected") : UIImage(named: "ic_radio_blank")
            self.titleLabel.textColor = newValue ? .colorBlack111111 : .colorB8B8B8
        }
    }
    
    @IBInspectable
    public var title: String {
        get {
            return self.titleLabel.text ?? ""
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
}

// MARK: - Actions
extension RadioButton {
    
    @IBAction func onPress(_ sender: UIButton) {
        delegate?.onClick(self)
    }
    
}
