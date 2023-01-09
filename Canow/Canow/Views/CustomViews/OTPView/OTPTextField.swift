//
//  OTPTextField.swift
//  Canow
//
//  Created by PhuNT14 on 22/10/2021.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
    var previousTextField: UITextField?
    var nextTextFiled: UITextField?
    
    override func deleteBackward() {
        if let string = text {
            previousTextField?.becomeFirstResponder()
            if previousTextField == nil {
                self.configBorder(borderWidth: 1, borderColor: .colorBlack111111, cornerRadius: 8)
            } else {
                self.configBorder(borderWidth: 1, borderColor: .colorE5E5E5, cornerRadius: 8)
            }
            previousTextField?.configBorder(borderWidth: 1, borderColor: .colorBlack111111, cornerRadius: 8)
            if string.isEmpty {
                let character = Array(self.previousTextField?.text ?? "")
                self.previousTextField?.text = String(character[..<(character.count - 1)])
            } else {
                let character = Array(string)
                text = String(character[..<(character.count - 1)])
            }
        }
    }
}
