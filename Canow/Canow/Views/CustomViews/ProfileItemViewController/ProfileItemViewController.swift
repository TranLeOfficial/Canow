//
//  ProfileItemViewController.swift
//  Canow
//
//  Created by TuanBM6 on 12/16/21.
//

import UIKit

protocol ProfileItemProtocol: AnyObject {
    func profileItemSelected<T>(data: T, index: Int)
}

class ProfileItemViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var heightContentView: NSLayoutConstraint!
    @IBOutlet private weak var dismisView: UIView!
    @IBOutlet private weak var contentView: UIView! {
        didSet {
            self.contentView.clipsToBounds = true
            self.contentView.layer.cornerRadius = 24
        }
    }
    @IBOutlet private weak var closeImageView: UIImageView!
    @IBOutlet private weak var nameTypeLabel: UILabel!
    @IBOutlet private weak var profileTableView: UITableView! {
        didSet {
            self.profileTableView.delegate = self
            self.profileTableView.dataSource = self
            self.profileTableView.registerReusedCell(cellNib: UpdateInfoCell.self)
        }
    }
    
    // MARK: - Properties
    var itemSeletectIndex: Int?
    var dataList = [String]()
    var onSelectedItem: (Int) -> Void = { _ in }
    var titleText: String = ""
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}

// MARK: - Methods
extension ProfileItemViewController {
    
    private func setupUI() {
        self.dismisView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissView)))
        self.closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissView)))
        
        let height = CGFloat(self.dataList.count * 50)
        let heightView = height + 60
        self.heightContentView.constant = heightView > self.heightContentView.constant ? self.heightContentView.constant : heightView
        
        if let index = self.itemSeletectIndex {
            self.profileTableView.selectRow(at: IndexPath(item: index, section: 0),
                                            animated: true,
                                            scrollPosition: .middle)
        }
        self.nameTypeLabel.text = titleText
    }
    
}

// MARK: - Actions
extension ProfileItemViewController {
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellNib: UpdateInfoCell.self)
        cell?.configure(data: self.dataList[indexPath.row])
        return cell ?? BaseTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSelectedItem(indexPath.row)
        self.dismiss(animated: true)
    }
    
}
