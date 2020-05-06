//
//  UserDefault+Helpers.swift
//  Wishlist
//
//  Created by Christian Konnerth on 24.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    public struct Keys {
        public static let groupKey = "group.wishlists-app.wishlists"
        
        public static let dataSourceKey = "dataSourceKey"
    }
    

    
    func setDataSourceArray(data: [Wishlist]){
        set(try? PropertyListEncoder().encode(data), forKey: Keys.dataSourceKey)
        synchronize()
    }
    
    func getDataSourceArray() -> [Wishlist]? {
        if let data = UserDefaults(suiteName: UserDefaults.Keys.groupKey)!.value(forKey: Keys.dataSourceKey) as? Data {
            if let dataSourceArray =
                try? PropertyListDecoder().decode(Array < Wishlist > .self, from: data) as[Wishlist] {
                    return dataSourceArray
                }
        }
        return nil
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
    
}
