//
//  MainNavigationControllerViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 23.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

class MainNavigationControllerViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
            let homeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            viewControllers = [homeController]
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        // save data to userDefaults
        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
            return defaults.isLoggedIn()
        } else {
            print("error getting logged in userdefaults")
            return false
        }
    }
}
