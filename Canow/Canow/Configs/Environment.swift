//
//  Environment.swift
//  Canow
//
//  Created by hieplh2 on 10/02/21.
//

import Foundation

public enum AppEnvironment {

    /// Development environment.
    case development
    
    /// QA environment.
    case qa
    
    /// UAT environment.
    case uat

    /// Production environment.
    case production
    
}

public struct App {

    // App environment: set in Build Settings > Other Swift Flags.
    #if DEVELOPMENT
    /// Development environment.
    public static let environment = AppEnvironment.development
    #elseif QA
    /// QA environment.
    public static let environment = AppEnvironment.qa
    #elseif UAT
    /// UAT environment.
    public static let environment = AppEnvironment.uat
    #else
    /// Production environment.
    public static let environment = AppEnvironment.production
    #endif
    
}
