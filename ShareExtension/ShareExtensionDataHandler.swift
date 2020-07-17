//
//  File.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 16.07.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShareExtensionDataHandler {
    //MARK: saveWish
    static func saveWish(dataSourceArray: [Wishlist], selectedWishlistIdx: Int, wish: Wish, finished: @escaping (_ done: Bool) -> Void ){
        // get name from current Whishlist
        let wishListName = dataSourceArray[selectedWishlistIdx].name

        let db = Firestore.firestore()
        var userId = ""
        // get uid
        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
            if let uid = defaults.getUid() {
                userId = uid
                print(uid)
                defaults.synchronize()
            } else {
                finished(false)
            }
        }
        // auto create "wünsche" - collection and add wish
        self.getWishCounter { (success, counter) in
            if success && counter != nil {
                guard let counter = counter as? Int else {
                    finished(false)
                    return
                }
                print(counter)
                let batch = db.batch()
                
                // update listCounter
                let userRef = Firestore.firestore().collection("users").document(userId)
                batch.updateData(["wishCounter": counter + 1], forDocument: userRef)
                
                // save wishlist with properties
                let wishRef = db.collection("users").document(userId).collection("wishlists").document(wishListName).collection("wünsche").document(wish.name)
                
                // check if wish has image: if yes -> wait for uplaod else commit batch
                if wish.image != nil && wish.image!.hasContent {
                    uploadImage(wish: wish, wishListName: wishListName) { (success, urlString) in
                        if success {
                            batch.setData(["name": wish.name,
                                           "link": wish.link,
                                           "price": wish.price,
                                           "note": wish.note,
                                           "wishlistIDX": selectedWishlistIdx,
                                           "wishCounter": counter,
                                           "imageUrl": urlString],
                                          forDocument: wishRef)
                            batch.commit { (error) in
                                if error != nil {
                                    finished(false)
                                } else {
                                    print("yeeey")
                                    finished(true)
                                }
                            }
                        } else {
                            print("upload fail")
                        }
                    }
                } else {
                    // set data with empty image url
                    batch.setData(["name": wish.name, "link": wish.link, "price": wish.price, "note": wish.note, "wishlistIDX": selectedWishlistIdx, "wishCounter": counter, "imageUrl": ""], forDocument: wishRef)
                    batch.commit { (error) in
                        if error != nil {
                            finished(false)
                        } else {
                            finished(true)
                        }
                    }
                }
            }
        }
    }
    //MARK: uploadImage
    static func uploadImage(wish: Wish, wishListName: String, finished: @escaping (_ success: Bool, _ resultString: String) -> Void){
        print("uploadImage")
        guard let imageData = wish.image?.jpegData(compressionQuality: 1.0) else { finished(false, ""); return }
        print("image data correct")
        // create unique imageName
        let imageName = UUID().uuidString
        do {
            try Auth.auth().useUserAccessGroup(UserDefaults.Keys.groupKey)
        } catch let error as NSError {
          print("Error changing user access group: %@", error)
        }
        let imageRef = Storage.storage().reference().child("images").child(imageName)
        imageRef.putData(imageData, metadata: nil) { (metaData, err) in
            if err != nil {
                print(err?.localizedDescription as Any)
                finished(false, "")
                return
            }
            imageRef.downloadURL { (url, err) in
                if err != nil {
                    print("err2")
                    finished(false, "")
                    return
                }
                
                guard let url = url else {
                    print("err3")
                    finished(false, "")
                    return
                }
                let urlString = url.absoluteString
                finished(true, urlString)
            }
        }
    }
    
    //MARK: getWishCounter
    static func getWishCounter(finished: @escaping (_ done: Bool, _ counter: Any?) -> Void) {
             
        let db = Firestore.firestore()
        var userId = ""
        // get uid
        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
            if let uid = defaults.getUid() {
                userId = uid
                defaults.synchronize()
            } else {
                finished(false, nil)
            }
        }
        
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let property = document.get("wishCounter")
                finished(true, property as! Int)
            } else {
                print("Document does not exist")
                finished(false, nil)
            }
        }
    }
}
