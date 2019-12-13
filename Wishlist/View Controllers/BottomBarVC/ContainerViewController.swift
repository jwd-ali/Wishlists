//
//  ContainerViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 16.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addWishButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("addWishButtonTapped"), object: nil)
    }
}
