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
    @IBOutlet weak var dropdownLanguage: DropDownView! {
        didSet {
            self.dropdownLanguage.dropDownTextField.placeholder = "Choose language"
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    let languageArray = [StringConstants.englishLanguage.localized, StringConstants.japaneseLanguage.localized]
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

// MARK: - Methods
extension LanguageSettingViewController {
    
    func setupUI() {
        self.title = StringConstants.languageSetting.localized
        self.dropdownLanguage.setDropDownDataSource(array: languageArray)
    }
    
}

// MARK: - Action
extension LanguageSettingViewController {
    @IBAction func saveActionButton(_ sender: UIButton) {
        if self.dropdownLanguage.dropDownTextField.text == languageArray[0] {
            Localize.update(language: "en")
        } else if self.dropdownLanguage.dropDownTextField.text == languageArray[1] {
            Localize.update(language: "ja")
        }
        self.pop()
    }
}
