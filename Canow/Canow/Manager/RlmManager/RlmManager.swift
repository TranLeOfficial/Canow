//
//  RlmManager.swift
//  Canow
//
//  Created by TuanBM6 on 10/8/21.
//

import Foundation
import RealmSwift

class RlmManager: NSObject {
    
    class func migration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: Version.REALM_VERSION)
    }
    
    class func getListModel<T: Object>(_ object: T.Type,
                                       predicate: NSPredicate? = nil,
                                       seqKey: String? = nil,
                                       ascending: Bool = false) -> [T] {
        do {
            let realm = try Realm()
            var results: Results<T>?
            
            if let predicate = predicate {
                results = realm.objects(object.self).filter(predicate)
            } else {
                results = realm.objects(object.self)
            }
            
            if let seqKey = seqKey {
                return results?.sorted(byKeyPath: seqKey, ascending: ascending).toArray(ofType: object.self) ?? []
            }
            
            return results?.toArray(ofType: object.self) ?? []
        } catch let error {
            print("getListModel error \(error)")
            return []
        }
    }
    
    class func getModel<T: Object>(_ object: T.Type, predicate: NSPredicate? = nil) -> T? {
        do {
            let realm = try Realm()
            var results: Results<T>?
            
            if let predicate = predicate {
                results = realm.objects(object.self).filter(predicate)
            } else {
                results = realm.objects(object.self)
            }
            
            if let results = results, !results.isEmpty {
                return Array(results).first
            }
            
            return nil
        } catch let error {
            print("getModel error \(error)")
            return nil
        }
    }
    
    class func saveModel<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch let error {
            print("saveModel error \(error)")
        }
    }
    
    class func deleteModel<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print("deleteModel error \(error)")
        }
    }
    
    class func deleteAll() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print("deleteAll error \(error)")
        }
    }
    
}

extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        
        for item in self {
            if let result = item as? T {
                array.append(result)
            }
        }
        
        return array
    }
    
}
