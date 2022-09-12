//
//  Task.swift
//  To-do list
//
//  Created by Kyrylo Tokar on 2022-09-09.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
  
    func setValueForUser(value: [User]?) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: "User")
    }
    
    func getValueForUser() -> [User]? {
        var existingUser = [User]()
        if let data = UserDefaults.standard.value(forKey:"User") as? Data {
            existingUser = try! PropertyListDecoder().decode(Array<User>.self, from: data)
        }
        return existingUser
    }
    
}
