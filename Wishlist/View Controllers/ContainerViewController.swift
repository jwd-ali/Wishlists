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
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
