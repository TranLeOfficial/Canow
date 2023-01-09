//
//  MoreLessLabel.swift
//  Canow
//
//  Created by TuanBM6 on 1/14/22.
//

import UIKit

class MoreLessLabel: UILabel {
    
    // MARK: - Properties
    var fullText: String? {
        didSet {
            self.collapse()
            self.setUpUI()
        }
    }
    var numOfLines: Int = 0 {
        didSet {
        }
    }
    private var isTruncated = true
    
}

// MARK: - Methods
extension MoreLessLabel {
    
    private func setUpUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tap)
    }
    
    private func collapse() {
        guard let fullText = self.fullText else {
            return
        }
        var arrayString = Array(fullText)
        let seeMoreText = StringConstants.s17BtnSeeMore.localized
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color646464, NSAttributedString.Key.font: UIFont.font(with: .regular400, size: 14)]
        
        let seeMoreAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color646464, NSAttributedString.Key.font: UIFont.font(with: .bold700, size: 14)]
        
        let seeMore = NSMutableAttributedString(string: seeMoreText, attributes: seeMoreAttributes)
        
        let range = (seeMoreText as NSString).range(of: seeMoreText)
        seeMore.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
        
        let decriptionAttibuted = NSMutableAttributedString(string: fullText, attributes: textAttributes)
        self.attributedText = decriptionAttibuted
        if self.calculateMaxLines() <= numOfLines {
            self.isUserInteractionEnabled = false
            return
        }
        
        self.text = ""
        var decriptionText = ""
        var string = ""
        for item in arrayString where self.calculateMaxLines() <= numOfLines {
            decriptionText += "\(String(item))"
            string += "\(String(item)) \(seeMoreText)"
            let info = NSMutableAttributedString(string: string, attributes: textAttributes)
            self.attributedText = info
            string = decriptionText
        }
        
        arrayString = Array(decriptionText)
        decriptionText = ""
        let array = arrayString[0...(arrayString.count - seeMoreText.count)]
        for item in array {
            decriptionText += "\(item)"
        }
        decriptionText += " "
        let decription = NSMutableAttributedString(string: decriptionText, attributes: textAttributes)
        decription.append(seeMore)
        self.attributedText = decription
        isTruncated = true
    }
    
    private func expand() {
        guard let fullText = self.fullText else {
            return
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color646464, NSAttributedString.Key.font: UIFont.font(with: .regular400, size: 14)]
        let info = NSMutableAttributedString(string: fullText + " ", attributes: textAttributes)
        
        let seeLessText = StringConstants.s17BtnSeeLess.localized
        let seeLessAttributes = [NSAttributedString.Key.foregroundColor: UIColor.color646464, NSAttributedString.Key.font: UIFont.font(with: .bold700, size: 14)]
        
        let seeLess = NSMutableAttributedString(string: seeLessText, attributes: seeLessAttributes)
        
        let range = (seeLessText as NSString).range(of: seeLessText)
        seeLess.addAttributes([NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue], range: range)
        
        info.append(seeLess)
        self.attributedText = info
        isTruncated = false
    }
    
}

// MARK: - Actions
extension MoreLessLabel {
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        if self.isTruncated {
            self.expand()
        } else {
            self.text = ""
            self.collapse()
        }
    }
    
}
