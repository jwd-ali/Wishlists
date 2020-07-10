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
        
        public static let dropOptionsKey = "dropOptionsKey"
    }
    
    func setDataSourceArray(data: [Wishlist]?){
        set(try? PropertyListEncoder().encode(data), forKey: Keys.dataSourceKey)
        synchronize()
    }
    

    func getDataSourceArray() -> [Wishlist]? {
    do {
        guard let data = self.value(forKey: Keys.dataSourceKey) as? Data else {
            // if there is exception or there is no value
            return nil
        }
        guard let dataSourceArray = try PropertyListDecoder().decode(Array < Wishlist > .self, from: data) as? [Wishlist]
            else { return nil
            }
        return dataSourceArray

        } catch {

        }
        return nil
    }
    
    func setDropOptions(dropOptions: [DropDownOption]?) {
        set(try? PropertyListEncoder().encode(dropOptions), forKey: Keys.dataSourceKey)
        synchronize()
    }
    
    func getDropOptions() -> [DropDownOption]? {
        if let data = self.value(forKey: Keys.dropOptionsKey) as? Data {
            if let dropDownOptions =
                try? PropertyListDecoder().decode(Array < DropDownOption > .self, from: data) as[DropDownOption] {
                    return dropDownOptions
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
