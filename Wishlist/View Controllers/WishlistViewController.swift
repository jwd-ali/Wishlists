//
//  WishlistViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 16.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit



class WishlistViewController: UIViewController {
    
    let theView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 30
        return v
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
         //set View to bottom
             self.theView.transform = CGAffineTransform(translationX: 0, y: 1000)
        
         //animate View
         UIView.animate(withDuration: 0.7, delay: 1, options: .curveEaseIn, animations: {
             self.theView.transform = CGAffineTransform(translationX: 0, y: 0)
         })

        
        view.addSubview(theView)
        
        NSLayoutConstraint.activate([
            theView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180.0),
            theView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            theView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
        ])
        

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
