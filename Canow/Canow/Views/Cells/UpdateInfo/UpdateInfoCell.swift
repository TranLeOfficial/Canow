//
//  UpdateInfoCell.swift
//  Canow
//
//  Created by TuanBM6 on 12/16/21.
//

import UIKit

class UpdateInfoCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var iconSelectImageView: UIImageView!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.iconSelectImageView.isHidden = !selected
    }
    
    override func configure<T>(data: T) {
        guard let data = data as? String else { return }
        self.nameLabel.text = data
    }
    
    override func prepareForReuse() {
        self.iconSelectImageView.isHidden = true
    }
    
}
