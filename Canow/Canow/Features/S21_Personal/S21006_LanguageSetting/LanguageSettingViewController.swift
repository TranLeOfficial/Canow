//
//  LanguageSettingViewController.swift
//  Canow
//
//  Created by PhuNT14 on 12/10/2021.
//

import UIKit
import Localize

class LanguageSettingViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView! {
        didSet {
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var languageLabel: UILabel! {
        didSet {
            self.languageLabel.text = StringConstants.s07LanguageSetting.localized
        }
    }
    @IBOutlet weak var jpRadioImageView: UIImageView!
    @IBOutlet weak var jpLabel: UILabel! {
        didSet {
            self.jpLabel.text = StringConstants.s07JanpaneseLanguage.localized
        }
    }
    @IBOutlet weak var enRadioImageView: UIImageView!
    @IBOutlet weak var enLabel: UILabel! {
        didSet {
            self.enLabel.text = StringConstants.s07EnglishLanguage.localized
        }
    }
    @IBOutlet weak var saveButton: CustomButton! {
        didSet {
            self.saveButton.setTitle(StringConstants.s07BtnSave.localized, for: .normal)
            self.saveButton.setTitle(StringConstants.s07BtnSave.localized, for: .highlighted)
            self.saveButton.setupUI()
        }
    }
    
    // MARK: - Properties
    var currentSelected = 0
    private let viewModel = LanguageSettingViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func bindViewAndViewModel() {
        self.reloadData()
        self.fetchDataFailure()
    }
    
}

// MARK: - Methods
extension LanguageSettingViewController {
    
    private func setupUI() {
        self.currentSelected = Localize.shared.currentLanguage == "ja" ? 0 : 1
        self.updateRadio()
    }
    
    private func updateRadio() {
        if self.currentSelected == 0 {
            self.jpRadioImageView.image = UIImage(named: "ic_radio_selected")
            self.enRadioImageView.image = UIImage(named: "ic_radio_blank")
        } else {
            self.jpRadioImageView.image = UIImage(named: "ic_radio_blank")
            self.enRadioImageView.image = UIImage(named: "ic_radio_selected")
        }
    }
    
    private func reloadData() {
        self.viewModel.changeLanguageSuccess = {
            Localize.update(language: self.currentSelected == 0 ? "ja" : "en")
            self.dismiss(animated: true)
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.changeLanguageFailure = { error in
            self.dismiss(animated: true)
            if !CommonManager.checkAuthenticateError(error) {
                return
            }
        }
    }
    
}

// MARK: - Actions
extension LanguageSettingViewController {
    
    @IBAction func changeJapanese(_ sender: Any) {
        self.currentSelected = 0
        self.updateRadio()
    }
    
    @IBAction func changeEnglish(_ sender: Any) {
        self.currentSelected = 1
        self.updateRadio()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if KeychainManager.apiIdToken() != nil {
            self.viewModel.changeLanguage(language: self.currentSelected == 0 ? "ja" : "en")
        } else {
            UserDefaultManager.language = self.currentSelected == 0 ? "ja" : "en"
            self.dismiss(animated: true)
        }
    }
    
}
