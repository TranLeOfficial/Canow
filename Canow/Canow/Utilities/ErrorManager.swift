//
//  ErrorManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/6/21.
//

import Foundation

enum MessageCode: String, Decodable {
    case E001, E002, E003, E004, E005, E006, E007, E008, E009, E010,
         E011, E012, E013, E014, E015, E016, E017, E018, E019, E020,
         E021, E022, E023, E024, E025, E026, E027, E028, E029, E030,
         E031, E032, E033, E034, E035, E036, E037, E038, E400, E403,
         E500, E087, E049, E065, E067, E053, E054, E071, E072, E075,
         E076, E077, E078, E109
    case C001
    case E005Reset, E005Login
    case SUCCESSFUL
    
    var message: String {
        return self.rawValue.localized
    }
}
