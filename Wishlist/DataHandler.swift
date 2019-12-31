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
                    self.welcomeLabel.text = "Hi " + (documentData?["firstname"] as! String) + "!"
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
        let wishListName = self.dataSourceArray[currentWishListIDX].name
        
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
        
//        // local mutable "WishList" var
//        var wList: [Wish] = [Wish]()
        
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
//                        self.wishListImagesArray.append(UIImage(named: "iconRoundedImage")!)
//                        self.wishListTitlesArray.append(listName as! String)
                        self.dataSourceArray.append(Wishlist(name: listName as! String, image: UIImage(named: "iconRoundedImage")!, wishData: [Wish]()))
                        // set the drop down menu's options
                        self.dropDownButton.dropView.dropDownOptions.append(listName as! String)
                        self.dropDownButton.dropView.dropDownListImages.append(UIImage(named: "iconRoundedImage")!)
                    }else {
//                        self.wishListTitlesArray.append(listName as! String)
//                        self.wishListImagesArray.append(self.images[listImageIDX as! Int])
                        
                        self.dataSourceArray.append(Wishlist(name: listName as! String, image: self.images[listImageIDX as! Int], wishData: [Wish]()))
                        
                        self.dropDownButton.dropView.dropDownOptions.append(listName as! String)
                        self.dropDownButton.dropView.dropDownListImages.append(self.images[listImageIDX as! Int])
                    }
                    
//                    // create an empty wishlist
//                    wList = [Wish]()
//                    self.userWishListData.append(wList)
                    
                    // reload collectionView and tableView
                    self.theCollectionView.reloadData()
                    self.dropDownButton.dropView.tableView.reloadData()
                    
                }
                
            }
            self.getWishes()
        }
        
        // un-hide the collection view
        self.theCollectionView.isHidden = false
        
        
                
    }
    
    func getWishes (){
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
       
        var counter = 0
       
        for list in self.dataSourceArray {
            db.collection("users").document(userID).collection("wishlists").document(list.name).collection("wünsche").getDocuments() { ( querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    // DMAG - create a new Wish array
                    var wList: [Wish] = [Wish]()
                    for document in querySnapshot!.documents {
                        let documentData = document.data()
                        let wishName = documentData["name"]
                        wList.append(Wish(withWishName: wishName as! String, checked: false))
                    }
                    // DMAG - set the array of wishes to the userWishListData
                    self.dataSourceArray[counter].wishData = wList
                    counter += 1
                }
            }
        }
    }
}
