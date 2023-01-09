//
//  ThemeRlmManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/9/21.
//

import Foundation
import RealmSwift

extension RlmManager {
    public class func getThemeById(id: Int) -> ThemeInfo? {
        let predicate = NSPredicate(format: "themeId = %@", argumentArray: [id])
        let themeInfo = self.getModel(ThemeInfo.self, predicate: predicate)
        return themeInfo
    }
    
    public class func saveTheme(theme: ThemeInfo) {
        self.saveModel(theme)
    }
}
