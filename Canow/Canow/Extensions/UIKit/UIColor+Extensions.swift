//
//  UIColor+Extensions.swift
//  Plass
//
//  Created by hieplh2 on 10/02/21.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }

    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F", "F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}

extension UIColor {

    static var accentColor: UIColor { return UIColor(named: "AccentColor")! }
    static var colorBlack111111: UIColor { return UIColor(hexString: "#111111") }
    static var colorYellowFDD000: UIColor { return UIColor(hexString: "#FDD000") }
    static var colorYellowFFCC00: UIColor { return UIColor(hexString: "#FFCC00") }
    static var colorRedEB2727: UIColor { return UIColor(hexString: "#EB2727") }
    static var colorE5E5E5: UIColor { return UIColor(hexString: "#E5E5E5") }
    static var colorGreen339A06: UIColor { return UIColor(hexString: "#339A06") }
    static var color646464: UIColor { return UIColor(hexString: "#646464") }
    static var colorB8B8B8: UIColor { return UIColor(hexString: "#B8B8B8") }
    static var colorE5E5E580: UIColor { return UIColor(hexString: "#E5E5E5").withAlphaComponent(0.5) }
    static var colorFDD10033: UIColor { return UIColor(hexString: "#FDD100").withAlphaComponent(0.2) }
    static var colorC4C4C4: UIColor { return UIColor(hexString: "#C4C4C4") }
    static var color339A06: UIColor { return UIColor(hexString: "#339A06") }
    static var color0000001F: UIColor { return UIColor(hexString: "#000000").withAlphaComponent(0.2) }
    static var color000000Alpha10: UIColor { return UIColor(hexString: "#000000").withAlphaComponent(0.05) }
    static var color000000Alpha70: UIColor { return UIColor(hexString: "#000000").withAlphaComponent(0.7) }
    static var colorF4F4F4: UIColor { return UIColor(hexString: "#F4F4F4") }
    static var color1E237B: UIColor { return UIColor(hexString: "#1E237B") }
    static var color5D5D5D: UIColor { return UIColor(hexString: "#5D5D5D") }
    static var colorF8F8F8: UIColor { return UIColor(hexString: "#F8F8F8") }
}

/// Color using hex color
/// - Parameters:
///   - hexString: hex string
///   - alpha: alpha
extension UIColor {

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var mHexTring = hexString
        if hexString.replacingOccurrences(of: "#",
                                          with: "",
                                          options: NSString.CompareOptions.literal,
                                          range: nil).count != 6 {
            mHexTring = "#1D89DA"
        }
        var hexFormatted: String = mHexTring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}
