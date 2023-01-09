//
//  CustomTabItem.swift
//  Canow
//
//  Created by hieplh2 on 29/12/2021.
//

import UIKit

class CustomTabItem: UIView {
    
    // MARK: - Properties
    private var activeItem: Int = 0
    private var previousActiveItem: Int = 0
    private var titleLabelList = [UILabel]()
    private var imageViewList = [UIImageView]()
    private var themInfo: TeamTheme {
        return DataManager.shared.getTheme()
    }
    
    var itemTapped: ((_ tab: Int) -> Void) = { _ in }
    var selectedColor: UIColor = .colorYellowFFCC00 {
        didSet {
            self.imageViewList[self.activeItem].setImageColor(self.selectedColor)
        }
    }
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabBarItem], currentTab: Int, frame: CGRect) {
        self.init(frame: frame)
        self.commonInit(menuItems: menuItems, currentTab: currentTab, frame: frame)
    }
    
}

// MARK: - Methods
extension CustomTabItem {
    
    private func commonInit(menuItems: [TabBarItem], currentTab: Int, frame: CGRect) {
        for index in 0 ..< menuItems.count {
            let itemWidth = frame.width / CGFloat(menuItems.count)
            let offsetX = itemWidth * CGFloat(index)
            
            let itemView = self.createTabItem(item: menuItems[index])
            itemView.tag = index
            
            self.addSubview(itemView)
            
            itemView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(offsetX)
                make.height.equalToSuperview()
                make.width.equalTo(itemWidth)
            }
            
            self.layoutIfNeeded()
        }
        
        self.activateTab(tab: currentTab)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.onChangedTab),
                                               name: NSNotification.tabBarChanged,
                                               object: nil)
    }
    
    private func createTabItem(item: TabBarItem) -> UIView {
        let tabBarItem = UIView()
        tabBarItem.clipsToBounds = true
        
        let itemTitleLabel = UILabel()
        itemTitleLabel.text = item.title
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.textColor = .colorB8B8B8
        itemTitleLabel.font = UIFont.font(with: .medium500, size: 10)
        
        let itemImageView = UIImageView()
        itemImageView.image = item.image
        itemImageView.setImageColor(.colorB8B8B8)
        itemImageView.contentMode = .scaleAspectFit
        
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.addSubview(itemImageView)
        
        self.titleLabelList.append(itemTitleLabel)
        self.imageViewList.append(itemImageView)
        
        itemImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        itemTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(self.handleTap(_:))))
        
        return tabBarItem
    }
    
    private func changeTab(index: Int) {
        self.deactivateTab(tab: self.activeItem)
        self.activateTab(tab: index)
    }
    
    private func activateTab(tab: Int) {
        self.titleLabelList[tab].textColor = .colorBlack111111
        self.imageViewList[tab].setImageColor(self.themInfo.primaryColor)
        self.itemTapped(tab)
        self.activeItem = tab
    }
    
    private func deactivateTab(tab: Int) {
        self.titleLabelList[tab].textColor = .colorB8B8B8
        self.imageViewList[tab].setImageColor(.colorB8B8B8)
        self.previousActiveItem = tab
    }
    
}

extension CustomTabItem {
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.deactivateTab(tab: self.activeItem)
        self.activateTab(tab: sender.view!.tag)
    }
    
    @objc func onChangedTab(_ notification: NSNotification) {
        guard let index = notification.object as? Int else { return }
        self.changeTab(index: index)
    }
    
}
