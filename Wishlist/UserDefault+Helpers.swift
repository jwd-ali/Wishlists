//
//  UserDefault+Helpers.swift
//  Wishlist
//
//  Created by Christian Konnerth on 24.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")    }
}
