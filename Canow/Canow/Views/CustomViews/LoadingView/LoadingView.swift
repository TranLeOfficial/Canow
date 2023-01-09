//
//  LoadingView.swift
//  Canow
//
//  Created by TuanBM6 on 10/12/21.
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: ScreenSize.screenHeight))
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: ScreenSize.screenHeight))
        self.setupView()
    }
    
}

extension LoadingView {
    
    private func setupView() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
    }
    
}
