//
//  FakeLaunchScreenViewController.swift
//  Canow
//
//  Created by hieplh2 on 28/12/2021.
//

import UIKit

class FakeLaunchScreenViewController: BaseViewController {
    
    // MARK: - Properties
    private var viewModel = FakeLaunchScreenViewModel()
    var didFetchDataSuccess: () -> Void = {}
    var didFetchDataFailure: () -> Void = {}

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    override func bindViewAndViewModel() {
        self.fetchDataSuccess()
        self.fetchDataFailure()
    }

}

// MARK: - Methods
extension FakeLaunchScreenViewController {
    
    private func setupUI() {
        if UserDefaultManager.isRemember ?? false {
            self.viewModel.getCustomerInfo()
        } else {
            self.didFetchDataFailure()
        }
    }
    
    private func fetchDataSuccess() {
        self.viewModel.fetchDataSuccess = {
            self.didFetchDataSuccess()
        }
    }
    
    private func fetchDataFailure() {
        self.viewModel.fetchDataFailure = { _ in
            self.didFetchDataFailure()
        }
    }
    
}
