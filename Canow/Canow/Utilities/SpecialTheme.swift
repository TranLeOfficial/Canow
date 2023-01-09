//
//  SpecialTheme.swift
//  Canow
//
//  Created by hieplh2 on 14/01/2022.
//

import Foundation
import UIKit

enum IconButton {
    
    case exchange, transfer, info, topup, pay
    
    var image: UIImage? {
        switch self {
        case .exchange:
            return UIImage(named: "ic_exchange_special")
        case .transfer:
            return UIImage(named: "ic_transfer_special")
        case .info:
            return UIImage(named: "ic_information_special")
        case .topup:
            return UIImage(named: "ic_topup_special")
        case .pay:
            return UIImage(named: "ic_pay_special")
        }
    }
    
    var imageDefault: UIImage? {
        switch self {
        case .exchange:
            return UIImage(named: "ic_exchange")
        case .transfer:
            return UIImage(named: "ic_transfer")
        case .info:
            return UIImage(named: "ic_information")
        case .topup:
            return UIImage(named: "ic_topup")
        case .pay:
            return UIImage(named: "ic_pay")
        }
    }
    
}

struct TeamTheme {
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let textColor: UIColor
    let buttonActionColor: UIColor?
    let buttonTextColor: UIColor
    let selectedColor: UIColor
    let bgPattern1: UIImage?
    let bgPattern2: UIImage?
    let bgPattern4: UIImage?
    let bgPattern6: UIImage?
    let bgPattern7: UIImage?
    let unselectedTabColor: UIColor?
    let logoColor: UIColor?
}

struct TeamID {
    
    static let iconExchangeDefault = UIImage(named: "ic_exchange")
    static let iconTransferDefault = UIImage(named: "ic_transfer")
    static let iconInfoDefault = UIImage(named: "ic_information")
    static let iconTopupDefault = UIImage(named: "ic_topup")
    static let iconPayDefault = UIImage(named: "ic_pay")
    static let iconExchange = UIImage(named: "ic_exchange_special")
    static let iconTransfer = UIImage(named: "ic_transfer_special")
    static let iconInfo = UIImage(named: "ic_information_special")
    static let iconTopup = UIImage(named: "ic_topup_special")
    static let iconPay = UIImage(named: "ic_pay_special")
    
    static let DEFAULT_THEME = 0,
               GIRAVANZ = 17,
               BARDRAL = 76,
               FUSION = 77,
               MITO_HOLY_HOOK = 78,
               KAWAGUCHI = 79,
               SPERIO = 80,
               FUKUYAMA = 81
    
}

class SpecialTheme {
    
    static let themeDefault = TeamTheme(primaryColor: .colorYellowFFCC00,
                                        secondaryColor: .colorYellowFFCC00,
                                        textColor: .colorBlack111111,
                                        buttonActionColor: nil,
                                        buttonTextColor: .colorBlack111111,
                                        selectedColor: UIColor(hexString: "#FDD100", alpha: 0.2),
                                        bgPattern1: nil,
                                        bgPattern2: nil,
                                        bgPattern4: nil,
                                        bgPattern6: UIImage(named: "bg_balance_big"),
                                        bgPattern7: nil,
                                        unselectedTabColor: .colorB8B8B8,
                                        logoColor: .clear)
    
    static let themeData: [Int: TeamTheme] = [
        TeamID.GIRAVANZ: TeamTheme(primaryColor: UIColor(hexString: "#FFEF34"),
                                   secondaryColor: UIColor(hexString: "#E60012"),
                                   textColor: .colorBlack111111,
                                   buttonActionColor: UIColor(hexString: "#E60012"),
                                   buttonTextColor: .white,
                                   selectedColor: UIColor(hexString: "#EB2727", alpha: 0.2),
                                   bgPattern1: UIImage(named: "bg_pattern_1_giravanz"),
                                   bgPattern2: UIImage(named: "bg_pattern_2_giravanz"),
                                   bgPattern4: UIImage(named: "bg_pattern_4_giravanz"),
                                   bgPattern6: UIImage(named: "bg_pattern_6_giravanz"),
                                   bgPattern7: UIImage(named: "bg_pattern_7_giravanz"),
                                   unselectedTabColor: UIColor(hexString: "#888023"),
                                   logoColor: .white),
        TeamID.FUKUYAMA: TeamTheme(primaryColor: UIColor(hexString: "#E1C44E"),
                                   secondaryColor: UIColor(hexString: "#A12225"),
                                   textColor: .colorBlack111111,
                                   buttonActionColor: UIColor(hexString: "#E60012"),
                                   buttonTextColor: UIColor(hexString: "#FFFFF3"),
                                   selectedColor: UIColor(hexString: "#A12225", alpha: 0.2),
                                   bgPattern1: UIImage(named: "bg_pattern_1_fukuyama"),
                                   bgPattern2: UIImage(named: "bg_pattern_2_fukuyama"),
                                   bgPattern4: UIImage(named: "bg_pattern_4_fukuyama"),
                                   bgPattern6: UIImage(named: "bg_pattern_6_fukuyama"),
                                   bgPattern7: UIImage(named: "bg_pattern_7_fukuyama"),
                                   unselectedTabColor: UIColor(hexString: "#796B2F"),
                                   logoColor: .white),
        TeamID.KAWAGUCHI: TeamTheme(primaryColor: UIColor(hexString: "#2B264F"),
                                    secondaryColor: UIColor(hexString: "#96A8AC"),
                                    textColor: .white,
                                    buttonActionColor: UIColor(hexString: "#2B264F"),
                                    buttonTextColor: .white,
                                    selectedColor: UIColor(hexString: "#96A8AC", alpha: 0.2),
                                    bgPattern1: UIImage(named: "bg_pattern_1_kawaguchi"),
                                    bgPattern2: UIImage(named: "bg_pattern_2_kawaguchi"),
                                    bgPattern4: UIImage(named: "bg_pattern_4_kawaguchi"),
                                    bgPattern6: UIImage(named: "bg_pattern_6_kawaguchi"),
                                    bgPattern7: UIImage(named: "bg_pattern_7_kawaguchi"),
                                    unselectedTabColor: UIColor(hexString: "#9592A7"),
                                    logoColor: UIColor(hexString: "#96A8AC")),
        TeamID.SPERIO: TeamTheme(primaryColor: UIColor(hexString: "#0B3A8E"),
                                 secondaryColor: UIColor(hexString: "#DB74A2"),
                                 textColor: .white,
                                 buttonActionColor: UIColor(hexString: "#DB74A2"),
                                 buttonTextColor: .white,
                                 selectedColor: UIColor(hexString: "#DB74A2", alpha: 0.2),
                                 bgPattern1: UIImage(named: "bg_pattern_1_sperio"),
                                 bgPattern2: UIImage(named: "bg_pattern_2_sperio"),
                                 bgPattern4: UIImage(named: "bg_pattern_4_sperio"),
                                 bgPattern6: UIImage(named: "bg_pattern_6_sperio"),
                                 bgPattern7: UIImage(named: "bg_pattern_7_sperio"),
                                 unselectedTabColor: UIColor(hexString: "#859CC7"),
                                 logoColor: UIColor(hexString: "#DB74A2")),
        TeamID.MITO_HOLY_HOOK: TeamTheme(primaryColor: UIColor(hexString: "#0B408C"),
                                         secondaryColor: UIColor(hexString: "#E60012"),
                                         textColor: .white,
                                         buttonActionColor: UIColor(hexString: "#E60012"),
                                         buttonTextColor: .white,
                                         selectedColor: UIColor(hexString: "#E60012", alpha: 0.2),
                                         bgPattern1: UIImage(named: "bg_pattern_1_mito"),
                                         bgPattern2: UIImage(named: "bg_pattern_2_mito"),
                                         bgPattern4: UIImage(named: "bg_pattern_4_mito"),
                                         bgPattern6: UIImage(named: "bg_pattern_6_mito"),
                                         bgPattern7: UIImage(named: "bg_pattern_7_mito"),
                                         unselectedTabColor: UIColor(hexString: "#859FC6"),
                                         logoColor: .white),
        TeamID.FUSION: TeamTheme(primaryColor: UIColor(hexString: "#186738"),
                                 secondaryColor: .colorBlack111111,
                                 textColor: .white,
                                 buttonActionColor: .colorBlack111111,
                                 buttonTextColor: .white,
                                 selectedColor: UIColor(hexString: "#111111", alpha: 0.2),
                                 bgPattern1: UIImage(named: "bg_pattern_1_fusion"),
                                 bgPattern2: UIImage(named: "bg_pattern_2_fusion"),
                                 bgPattern4: UIImage(named: "bg_pattern_4_fusion"),
                                 bgPattern6: UIImage(named: "bg_pattern_6_fusion"),
                                 bgPattern7: UIImage(named: "bg_pattern_7_fusion"),
                                 unselectedTabColor: UIColor(hexString: "#8BB39B"),
                                 logoColor: UIColor(hexString: "#F3E605")),
        TeamID.BARDRAL: TeamTheme(primaryColor: UIColor(hexString: "#B82D29"),
                                  secondaryColor: .colorBlack111111,
                                  textColor: .white,
                                  buttonActionColor: .colorBlack111111,
                                  buttonTextColor: .white,
                                  selectedColor: UIColor(hexString: "#111111", alpha: 0.2),
                                  bgPattern1: UIImage(named: "bg_pattern_1_bardral"),
                                  bgPattern2: UIImage(named: "bg_pattern_2_bardral"),
                                  bgPattern4: UIImage(named: "bg_pattern_4_bardral"),
                                  bgPattern6: UIImage(named: "bg_pattern_6_bardral"),
                                  bgPattern7: UIImage(named: "bg_pattern_7_bardral"),
                                  unselectedTabColor: UIColor(hexString: "#DB9694"),
                                  logoColor: UIColor(hexString: "#DEC49D"))
    ]
    
}
