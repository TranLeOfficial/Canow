//
//  UserDefaults+Extensions.swift
//  Plass
//
//  Created by hieplh2 on 10/02/21.
//

import Foundation

extension UserDefaults {

    class func object(forKey key: String) -> Any? {
        let defaults = UserDefaults.standard

        let object = defaults.object(forKey: key)
        return object
    }

    class func setObject(_ object: Any?, forKey key: String) {
        let defaults = UserDefaults.standard

        defaults.set(object, forKey: key)
        defaults.synchronize()
    }

    class func removeObject(forKey key: String) {
        let defaults = UserDefaults.standard

        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }

}
