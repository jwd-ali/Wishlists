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

extension MainViewController {
    
    func setupWelcomeLabel() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).getDocument { (document, error) in
            // check for error
            if error == nil{
                // check if document exists
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.welcomeLabel.text = "Hi " + (documentData?["anzeigename"] as! String) + "."
                    // show + animate welcomeLabel
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                        self.welcomeLabel.transform = CGAffineTransform(translationX: 0, y: 0)
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
//        let wishListName = self.dataSourceArray[self.selectedWishlistIDX!].name
//        let wishIDX = self.selectedWishlistIDX
//
//        // auto create "wünsche" - collection and add Wish with name
//        let db = Firestore.firestore()
//        let userID = Auth.auth().currentUser!.uid
//        db.collection("users").document(userID).collection("wishlists").document(wishListName).collection("wünsche").document(self.popUpView.popUpTextField.text!).setData(["name": self.popUpView.popUpTextField.text!, "wishIDX": wishIDX!], completion: { (error) in
//            if error != nil{
//                print("Error saving Wish")
//            }
//        })
    }
    
    func saveWishlist() {
        
        // track Wishlist IDX
        self.wishlistIDX += 1

        // get user input
        let wishListName = self.listNameTextfield.text!
        let imageArrayIDX = self.currentImageArrayIDX!
        let wishListIDX = self.wishlistIDX
        
        // auto create custom Wishlist with name/listIDX/imageIDX
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("wishlists").document(wishListName).setData(["name": wishListName, "listIDX": wishListIDX, "imageIDX" : imageArrayIDX]) { (error) in
            if error != nil {
                print("Error saving Wishlist")
            }
        }
    }
    
    
    func retrieveUserDataFromDB() -> Void {
        getWishlists()
        
    }
    

    
    func getWishlists() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("wishlists").order(by: "listIDX").getDocuments() { ( querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                // get all documents from "wishlists"-collection and save attributes
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                    let listName = documentData["name"]
                    let listImageIDX = documentData["imageIDX"]
                    
                    // if-case for Main Wishlist
                    if listImageIDX as? Int == nil {
                        self.dataSourceArray.append(Wishlist(name: listName as! String, image: UIImage(named: "iconRoundedImage")!, wishData: [Wish](), color: Constants.ImageList.mainColor))
                        // set the drop down menu's options
                        self.theDropDownOptions.append(listName as! String)
                        self.theDropDownImageOptions.append(UIImage(named: "iconRoundedImage")!)
                    }else {
                        
                        self.dataSourceArray.append(Wishlist(name: listName as! String, image: Constants.ImageList.images[listImageIDX as! Int], wishData: [Wish](), color: Constants.ImageList.customColors[listImageIDX as! Int]))
                        
                        self.theDropDownOptions.append(listName as! String)
                        self.theDropDownImageOptions.append(Constants.ImageList.images[listImageIDX as! Int])
                    }
                    
                    // reload collectionView and tableView
                    self.theCollectionView.reloadData()
//                    self.dropDownButton.dropView.tableView.reloadData()
                    
                }
            }
            self.theCollectionView.isHidden = false
            self.getWishes()
        }
    }
    
    func getWishes() {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        
        
        for list in self.dataSourceArray {
             db.collection("users").document(userID).collection("wishlists").document(list.name).collection("wünsche").getDocuments() { ( querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // append every Wish to array at wishIDX
                    for document in querySnapshot!.documents {
                        let documentData = document.data()
                        let wishName = documentData["name"]
                        let wishIDX = documentData["wishIDX"]
//                        self.dataSourceArray[wishIDX as! Int].wishData.append(Wish(withWishName: wishName as! String, link: "", price: 0, note: "", checked: false))
                    }
                }
            }
        }
    }
}

class DataHandler {
    
    static func saveWishlist(wishListName: String, imageArrayIDX: Int, wishListIDX: Int) {
        
        // track Wishlist IDX
//        self.wishlistIDX += 1
        
        // auto create custom Wishlist with name/listIDX/imageIDX
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).collection("wishlists").document(wishListName).setData(["name": wishListName, "listIDX": wishListIDX, "imageIDX" : imageArrayIDX]) { (error) in
            if error != nil {
                print("Error saving Wishlist")
            }
        }
    }
    
    //MARK: signIn
    static func signIn(credentials: Any?, username: String, finished: @escaping (_ done: Bool) -> Void) {
        
        let listIDX = 1 // initialize list index to 1 for sorting when retrieving lists

        guard let credentials = credentials as? AuthCredential else {

            finished(false)
            return

        }
        
        let db = Firestore.firestore()

        Auth.auth().signIn(with: credentials, completion: { (result, error) in

            if let userId = result?.user.uid { // successfully signed in
                 
                let batch = db.batch()
                
                // Set username and uid for user
                let userRef = Firestore.firestore().collection("users").document(userId)
                batch.setData(["username": username, "uid": userId, "listIDX": listIDX], forDocument: userRef)

                // create empty 'Main Wishlist' with index 1 for sorting
                let listRef = db.collection("users").document(userId).collection("wishlists").document("Main Wishlist")
                batch.setData(["name": "Main Wishlist", "listIDX": listIDX], forDocument: listRef)

                batch.commit { (error) in

                    if let error = error {
                        Utilities.showErrorPopUp(labelContent: "Fehler", description: error.localizedDescription)
                        finished(false)
                    } else {
                        UserDefaults.standard.setIsLoggedIn(value: true)
                        UserDefaults.standard.synchronize()
                        finished(true) // sign-in process complete
                    }
                }

            } else { // could not sign in

                if let error = error {
                    Utilities.showErrorPopUp(labelContent: "Fehler", description: error.localizedDescription)
                }
                finished(false)
                return

            }
        })
    }
    
    //MARK: check username
    static func checkUsername(field: String, completion: @escaping (Bool) -> Void) {
        
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        collectionRef.whereField("username", isEqualTo: field).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            } else if (snapshot?.isEmpty)! {
                completion(false)
            } else {
                for document in (snapshot?.documents)! {
                    if document.data()["username"] != nil {
                        completion(true)
                    }
                }
            }
        }
    }
}
