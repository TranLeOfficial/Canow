//
//  ChooseDateViewController.swift
//  Canow
//
//  Created by TuanBM6 on 12/10/21.
//

import UIKit

class ChooseDateViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var dobDatePicker: UIDatePicker!
    
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 16
        }
    }
    
    @IBOutlet private weak var selectTimeLabel: UILabel! {
        didSet {
            self.selectTimeLabel.text = StringConstants.s01SelectTime.localized
            self.selectTimeLabel.textColor = .colorBlack111111
            self.selectTimeLabel.font = .font(with: .medium500, size: 18)
        }
    }
    
    @IBOutlet private weak var doneButton: CustomButton! {
        didSet {
            self.doneButton.layer.cornerRadius = 6
            self.doneButton.setTitle(StringConstants.s01BtnDone.localized, for: .normal)
            self.doneButton.setTitle(StringConstants.s01BtnDone.localized, for: .highlighted)
            self.doneButton.setupUI()
        }
    }

    // MARK: - Properties
    private var date: Date
    var onSelectedDate: (Date) -> Void = { _ in }
    
    // MARK: - Constructors
    init(date: Date) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
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
extension ChooseDateViewController {
    
    private func setupUI() {
        self.dobDatePicker.date = self.date
    }
    
}

// MARK: - Actions
extension ChooseDateViewController {
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func doneAction(_ sender: UIButton) {
        self.onSelectedDate(self.dobDatePicker.date)
        self.dismiss(animated: true)
    }
    
}
