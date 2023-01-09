//
//  BaseViewController.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit
import Localize

class BaseViewController: UIViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewAndViewModel()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.themeChanged),
                                               name: NSNotification.themeChanged,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.configLanguage),
                                               name: NSNotification.Name(localizeChangeNotification),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if KeychainManager.apiIdToken() == nil {
            DataManager.shared.deleteTheme()
        }
        self.updateTheme()
    }
    
    func bindViewAndViewModel() {}
    func updateTheme() {}
    
    @objc
    func configLanguage(_ notification: NSNotification) {}
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.themeChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(localizeChangeNotification), object: nil)
    }
    
}

// MARK: - Methods
extension BaseViewController {
    
    @objc func themeChanged(_ notification: NSNotification) {
        self.updateTheme()
    }
    
}
