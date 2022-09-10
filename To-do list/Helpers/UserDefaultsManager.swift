//
//  UserDefaultsManager.swift
//  Checker_ITEA
//
//  Created by Anastasia Bilous on 2022-07-31.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
  
    func setValueForUser(value: [Credentials]?) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: "SaveUser")
    }
    
    func getValueForUser() -> [Credentials]? {
        var existingUser = [Credentials]()
        if let data = UserDefaults.standard.value(forKey:"SaveUser") as? Data {
            existingUser = try! PropertyListDecoder().decode(Array<Credentials>.self, from: data)
        }
        return existingUser
    }
    
}
