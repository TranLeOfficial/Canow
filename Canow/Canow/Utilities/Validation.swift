//
//  CommonManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/8/21.
//

import Foundation

public enum Regex: String {
    case letter = "^(?=.*[a-zA-Z])",
         number = "^(?=.*[0-9])",
         specialCharacter = "^(?=.*[$@$!%*#?&])",
         giftCard = "^[a-zA-Z0-9]{5}-[a-zA-Z0-9]{5}-[a-zA-Z0-9]{5}$",
         alphaNumeric = "^[a-zA-Z0-9]+$"
}

class Validation {
    
    private class func validate(input: String, pattern: Regex) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern.rawValue, options: .caseInsensitive)
            let range = NSRange(location: 0, length: input.count)
            let result = regex.matches(in: input, options: [], range: range)
            if !result.isEmpty {
                return true
            }
        } catch {
            print("Regex error: \(error.localizedDescription)")
        }
        return false
    }
    
    public class func validateTextInput(str: String, pattern: Regex) -> Bool {
        return Validation.validate(input: str, pattern: pattern)
    }
    
}
