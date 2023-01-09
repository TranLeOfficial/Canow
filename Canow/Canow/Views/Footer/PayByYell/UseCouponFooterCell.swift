//
//  UseCouponFooterCell.swift
//  Canow
//
//  Created by NhanTT13 on 12/27/21.
//

import UIKit

class UseCouponFooterCell: UIView {
    private let payWithoutCoupon: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(payWithoutCoupon)

        self.payWithoutCoupon.snp.makeConstraints { make in
            make.centerX.centerY.width.height.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func setupLabel(text: String, color: UIColor, font: UIFont) {
        payWithoutCoupon.text = text
        payWithoutCoupon.textColor = color
        payWithoutCoupon.font = font
    }

}
