//
//  DataFirestoreHandler.swift
//  Wishlist
//
//  Created by Christian Konnerth on 09.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension ExampleViewController {
    
    func setupWelcomeLabel() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).getDocument { (document, error) in
            //check for error
            if error == nil{
                // check that document exists
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.welcomeTextLabel.text = "Hi " + (documentData?["firstname"] as! String) + "!"
                    // show + animate welcomeLabel
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                       
                        self.welcomeTextLabel.transform = CGAffineTransform(translationX: 278, y: 0)
                    })
                }else {
                    print("document doesn't exist")
                }
            }else {
                print("some error")
            }
        }
    }
    
    func saveWish() {
        
        // get name from current Whishlist
        let wishListName = self.wishListTitlesArray[currentWishListIDX]
        
        // auto create "wünsche" - collection and add Wish with name
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("wishlists").document(wishListName).collection("wünsche").document(self.popUpView.popUpTextField.text!).setData(["name": self.popUpView.popUpTextField.text!], completion: { (error) in
            if error != nil{
                print("Error saving Wish")
            }
        })
    }
    
    func saveWishlist() {
        
        // get user input
        let wishListName = self.listNameTextfield.text!
        
        // auto create custom Wishlist with wishListName
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("wishlists").document(wishListName).setData(["name": wishListName]) { (error) in
            if error != nil {
                print("Error saving Wishlist")
            }
        }
    }
}
