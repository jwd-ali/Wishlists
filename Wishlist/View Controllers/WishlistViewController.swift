//
//  WishlistViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 16.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit



class WishlistViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let theView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .darkGray
        v.layer.cornerRadius = 30
        return v
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
//        slideDown.direction = .down
//        view.addGestureRecognizer(slideDown)
        

        
        view.addSubview(theView)
        
        NSLayoutConstraint.activate([
            theView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 180.0),
            theView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            theView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
        ])
        
        
        self.view.sendSubviewToBack(theView)
        self.view.sendSubviewToBack(backgroundImage)
    }
    
//    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
//        self.dismiss(animated: false, completion: nil)
//        UIView.animate(withDuration: 0.4) {
//            if let theWindow = UIApplication.shared.keyWindow {
//                gesture.view?.frame = CGRect(x:theWindow.frame.width - 15 , y: theWindow.frame.height - 15, width: 10 , height: 10)
//            }
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
