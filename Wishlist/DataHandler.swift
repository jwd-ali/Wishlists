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
import FirebaseStorage
import Kingfisher

class DataHandler {
    
    //MARK: getWishlists
    static func getWishlists(completion: @escaping (_ success: Bool, _ dataArray: Any?, _ dropDownArray: Any?) -> Void) {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        var dataSourceArray = [Wishlist]()
        var dropOptions = [DropDownOption]()
        
        db.collection("users").document(userID).collection("wishlists").order(by: "listIDX").getDocuments() { ( querySnapshot, error) in
            if let error = error {
                Utilities.showErrorPopUp(labelContent: "Fehler", description: error.localizedDescription)
                completion(false, nil, nil)
            }else {
                let group = DispatchGroup()
                // get all documents from "wishlists"-collection and save attributes
                for document in querySnapshot!.documents {
                    group.enter()
                    let documentData = document.data()
                    let listName = documentData["name"]
                    let listImageIDX = documentData["imageIDX"]
                    let textColor = documentData["textColor"]
                    let index = documentData["listIDX"]
                    
                    guard let color = ColorMode(rawValue: textColor as! String) else {
                        print("handle invalid color error");
                        return
                    }

                    let colorUnwrapped = color.create
                        
                    dataSourceArray.append(Wishlist(name: listName as! String, image: Constants.Wishlist.images[listImageIDX as! Int], wishes: [Wish](), color: Constants.Wishlist.customColors[listImageIDX as! Int], textColor: colorUnwrapped, index: index as! Int))
                    dropOptions.append(DropDownOption(name: listName as! String, image: Constants.Wishlist.images[listImageIDX as! Int]))
                    group.leave()
                }
                // for loop is finished -> fire completion
                group.notify(queue: DispatchQueue.main) {
                    completion(true, dataSourceArray, dropOptions)
                }
            }
        }
    }
    
    //MARK: getWishes
    static func getWishes(dataSourceArray: [Wishlist], completion: @escaping (_ success: Bool, _ dataArray: [Wishlist]) -> Void){
        
        var dataSourceArrayWithWishes = dataSourceArray
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let imageView = UIImageView()
        imageView.image = UIImage()
        for list in dataSourceArray {
            db.collection("users").document(userID).collection("wishlists").document(list.name).collection("wünsche").order(by: "wishCounter").getDocuments() { ( querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false, dataSourceArrayWithWishes)
                } else {
                    // dispatch group to make sure completion only fires when for loop is finished
                    let dispatchGroup = DispatchGroup()
                    let dispatchQueue = DispatchQueue(label: "queue")
                    let dispatchSemaphore = DispatchSemaphore(value: 0)
                    // append every Wish to array at wishIDX
                    dispatchQueue.async {
                        for document in querySnapshot!.documents {
                            dispatchGroup.enter()
                            let documentData = document.data()
                            let name = documentData["name"] as? String ?? ""
                            let link = documentData["link"] as? String ?? ""
                            let price = documentData["price"] as? String ?? ""
                            let note = documentData["note"] as? String ?? ""
                            let imageUrlString = document["imageUrl"] as? String ?? ""
                            let wishIDX = documentData["wishlistIDX"] as? Int ?? 0
                            
                            // valid imageUrl -> download image
                            if let imageUrl = URL(string: imageUrlString) {
                                let resource = ImageResource(downloadURL: imageUrl)
                                imageView.kf.setImage(with: resource) { (result) in
                                    switch result {
                                    case .success(_):
                                        dataSourceArrayWithWishes[wishIDX].wishes.append(Wish(name: name, link: link, price: price, note: note, image: imageView.image!, checkedStatus: false))
                                        dispatchSemaphore.signal()
                                        dispatchGroup.leave()
                                    case .failure(_):
                                        dataSourceArrayWithWishes[wishIDX].wishes.append(Wish(name: name, link: link, price: price, note: note, image: UIImage(), checkedStatus: false))
                                        print("fail")
                                        dispatchSemaphore.signal()
                                        dispatchGroup.leave()
                                    }
                                }
                                
                            } else {
                                // no iage to downlaod -> append empty iage
                                dispatchSemaphore.wait()
                                dataSourceArrayWithWishes[wishIDX].wishes.append(Wish(name: name, link: link, price: price, note: note, image: UIImage(), checkedStatus: false))
                                dispatchGroup.leave()
                            }
                        }
                    }
                    
                    // for loop is finished -> fire completion
                    dispatchGroup.notify(queue: dispatchQueue) {
                        DispatchQueue.main.async {
                            completion(true, dataSourceArrayWithWishes)
                        }
                    }
                }
            }
        }
    }
    //MARK: getListCounter
    static func getListCounter(finished: @escaping (_ done: Bool, _ index: Any?) -> Void) {
             
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        
        let docRef = db.collection("users").document(userID)
        

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let property = document.get("listCounter")
                finished(true, property as! Int)
            } else {
                print("Document does not exist")
                finished(false, nil)
            }
        }
    }
    //MARK: updateWishlist
    static func updateWishlist(wishListName: String, oldListName: String, imageArrayIDX: Int, wishListIDX: Int, textColor: String) {

        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        let ref = db.collection("users").document(userID).collection("wishlists")
        
        if oldListName != wishListName { // name was changed
            ref.document(oldListName).getDocument { (document, error) in
                if error != nil {
                   Utilities.showErrorPopUp(labelContent: "Fehler beim Speichern1", description: (error?.localizedDescription)!)
                }else {
                    // get old document
                    if (document != nil && document!.exists) {
                        // save document.data to 'data'
                        let data = document?.data()
                        // create new document with 'data'
                        ref.document(wishListName).setData(data!) { (error) in
                            if error != nil {
                                Utilities.showErrorPopUp(labelContent: "Fehler beim Speichern2", description: (error?.localizedDescription)!)
                            } else {
                                // delete old document
                                ref.document(oldListName).delete { (error) in
                                    if error != nil {
                                        Utilities.showErrorPopUp(labelContent: "Fehler beim Speichern3", description: (error?.localizedDescription)!)
                                    } else {
                                        // set data for new document
                                        ref.document(wishListName).setData(["name": wishListName, "listIDX": wishListIDX, "imageIDX" : imageArrayIDX, "textColor": textColor]) { (error) in
                                            if error != nil {
                                                Utilities.showErrorPopUp(labelContent: "Fehler beim Speichern", description: (error?.localizedDescription)!)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else { // name wasn't changed
            db.collection("users").document(userID).collection("wishlists").document(wishListName).updateData(["name": wishListName, "listIDX": wishListIDX, "imageIDX" : imageArrayIDX, "textColor": textColor]) { (error) in
                if error != nil {
                    Utilities.showErrorPopUp(labelContent: "Fehler beim Speichern", description: (error?.localizedDescription)!)
                }
            }
        }
    }
    //MARK: saveWishlist
    static func saveWishlist(wishListName: String, imageArrayIDX: Int, textColor: String) {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        
        self.getListCounter { (success, index) in
            if success && index != nil {
                guard let wishListIDX = index as? Int else {
                    Utilities.showErrorPopUp(labelContent: "Fehler", description: "Wishlist konnte nicht gespeichert werden")
                    return
                }
                
                let batch = db.batch()
                
                // update listCounter
                let userRef = Firestore.firestore().collection("users").document(userID)
                batch.updateData(["listCounter": wishListIDX + 1], forDocument: userRef)
                
                // save wishlist with properties
                let listRef = db.collection("users").document(userID).collection("wishlists").document(wishListName)
                batch.setData(["name": wishListName, "listIDX": wishListIDX + 1, "imageIDX" : imageArrayIDX, "textColor": textColor], forDocument: listRef)
                
                batch.commit { (error) in
                    if let error = error {
                        Utilities.showErrorPopUp(labelContent: "Liste konnte nicht gespeichert werden", description: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //MARK: deleteWishlist
    static func deleteWishlist(_ listIndex: Int) -> Void {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid

        db.collection("users").document(userID).collection("wishlists").whereField("listIDX", isEqualTo: listIndex).getDocuments { (querySnapshot, error) in
            if error != nil {
                Utilities.showErrorPopUp(labelContent: "Fehler beim löschen", description: error!.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }

            }
        }
    }
    
    //MARK: saveWish
    static func saveWish(dataSourceArray: [Wishlist], selectedWishlistIdx: Int, wish: Wish) {
        // get name from current Whishlist
        let wishListName = dataSourceArray[selectedWishlistIdx].name

        // auto create "wünsche" - collection and add wish
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        
        self.getWishCounter { (success, counter) in
            if success && counter != nil {
                guard let counter = counter as? Int else {
                    Utilities.showErrorPopUp(labelContent: "Fehler", description: "Wunsch konnte nicht gespeichert werden")
                    return
                }
                
                let batch = db.batch()
                
                // update listCounter
                let userRef = Firestore.firestore().collection("users").document(userID)
                batch.updateData(["wishCounter": counter + 1], forDocument: userRef)
                
                // save wishlist with properties
                let wishRef = db.collection("users").document(userID).collection("wishlists").document(wishListName).collection("wünsche").document(wish.name)
                
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
                                if let error = error {
                                    Utilities.showErrorPopUp(labelContent: "Wunsch konnte nicht gespeichert werden", description: error.localizedDescription)
                                }
                            }
                        }
                        
                    }
                } else {
                    // set data with empty image url
                    batch.setData(["name": wish.name, "link": wish.link, "price": wish.price, "note": wish.note, "wishlistIDX": selectedWishlistIdx, "wishCounter": counter, "imageUrl": ""], forDocument: wishRef)
                    batch.commit { (error) in
                        if let error = error {
                            Utilities.showErrorPopUp(labelContent: "Wunsch konnte nicht gespeichert werden", description: error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    //MARK: uploadImage
    static func uploadImage(wish: Wish, wishListName: String, finished: @escaping (_ success: Bool, _ resultString: String) -> Void){
        
        guard let imageData = wish.image?.jpegData(compressionQuality: 1.0) else { finished(false, ""); return }
        // create unique imageName
        let imageName = UUID().uuidString
        
        let imageRef = Storage.storage().reference().child("images").child(imageName)
        imageRef.putData(imageData, metadata: nil) { (metaData, err) in
            if err != nil {
                finished(false, "")
                return
            }
            imageRef.downloadURL { (url, err) in
                if err != nil {
                    finished(false, "")
                    return
                }
                
                guard let url = url else {
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
        let userID = Auth.auth().currentUser!.uid
        
        let docRef = db.collection("users").document(userID)
        
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
    
    //MARK: signUpWithSocial
    static func signUpWithSocial(credentials: Any?, username: String, finished: @escaping (_ done: Bool) -> Void) {
        
        let listCounter = 1 // initialize list index to 1 for sorting when retrieving lists
        let wishCounter = 1 // initialize wish counter to 1 for sorting wishes when retrieving
        let imageArrayIDX = Constants.Wishlist.getCurrentImageIndex(image: UIImage(named: "iconRoundedImage")!)

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
                batch.setData(["username": username, "uid": userId, "listCounter": listCounter, "wishCounter": wishCounter], forDocument: userRef)

                // create empty 'Main Wishlist' with index 1 for sorting
                let listRef = db.collection("users").document(userId).collection("wishlists").document("Main Wishlist")
                batch.setData(["name": "Main Wishlist", "listIDX": listCounter, "imageIDX" : imageArrayIDX, "textColor": Constants.Wishlist.textColor.white], forDocument: listRef)

                batch.commit { (error) in

                    if let error = error {
                        Utilities.showErrorPopUp(labelContent: "Fehler", description: error.localizedDescription)
                        finished(false)
                    } else {
                        let uid = Auth.auth().currentUser!.uid
                        // set user status to logged-in
                        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                            defaults.setIsLoggedIn(value: true)
                            defaults.setUid(uid: uid)
                            defaults.synchronize()
                        }
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
    
    //MARK: signUpWithEmail
    static func signUpWithEmail(email: String, password: String, username: String, finished: @escaping (_ done: Bool) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let userId = result?.user.uid { // successfully signed in
                
                let listCounter = 1 // initialize list index to 1 for sorting when retrieving lists
                let wishCounter = 1 // initialize wish counter to 1 for sorting wishes when retrieving
                let imageArrayIDX = Constants.Wishlist.getCurrentImageIndex(image: UIImage(named: "iconRoundedImage")!)
                
                let db = Firestore.firestore()
                 
                let batch = db.batch()
                
                // Set username and uid for user
                let userRef = Firestore.firestore().collection("users").document(userId)
                batch.setData(["username": username, "uid": userId, "listCounter": listCounter, "wishCounter": wishCounter], forDocument: userRef)

                // create empty 'Main Wishlist' with index 1 for sorting
                let listRef = db.collection("users").document(userId).collection("wishlists").document("Main Wishlist")
                batch.setData(["name": "Main Wishlist", "listIDX": listCounter, "imageIDX" : imageArrayIDX, "textColor": Constants.Wishlist.textColor.white], forDocument: listRef)

                batch.commit { (error) in

                    if let error = error {
                        Utilities.showErrorPopUp(labelContent: "Fehler", description: error.localizedDescription)
                        finished(false)
                    } else {
                        do {
                            try Auth.auth().useUserAccessGroup(UserDefaults.Keys.groupKey)
                        } catch let error as NSError {
                          print("Error changing user access group: %@", error)
                        }
                        let uid = Auth.auth().currentUser!.uid
                        // set user status to logged-in
                        if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                            defaults.setIsLoggedIn(value: true)
                            defaults.setUid(uid: uid)
                            defaults.synchronize()
                        }
                        finished(true) // sign-in process complete
                    }
                }
            }
        }
    }
    
    //MARK: signInWithApple
    static func signInWithApple(username: String, finished: @escaping (_ done: Bool) -> Void) {
        
        let db = Firestore.firestore()
        let batch = db.batch()
        do {
            try Auth.auth().useUserAccessGroup(UserDefaults.Keys.groupKey)
        } catch let error as NSError {
          print("Error changing user access group: %@", error)
        }
        let userId = Auth.auth().currentUser!.uid
        let listCounter = 1 // initialize list index to 1 for sorting when retrieving lists
        let wishCounter = 1 // initialize wish counter to 1 for sorting wishes when retrieving
        let imageArrayIDX = Constants.Wishlist.getCurrentImageIndex(image: UIImage(named: "iconRoundedImage")!)
        
        // Set username and uid for user
        let userRef = Firestore.firestore().collection("users").document(userId)
        batch.setData(["username": username, "uid": userId, "listCounter": listCounter, "wishCounter": wishCounter], forDocument: userRef)

        // create empty 'Main Wishlist' with index 1 for sorting
        let listRef = db.collection("users").document(userId).collection("wishlists").document("Main Wishlist")
        batch.setData(["name": "Main Wishlist", "listIDX": listCounter, "imageIDX" : imageArrayIDX, "textColor": Constants.Wishlist.textColor.white], forDocument: listRef)

        batch.commit { (error) in

            if let error = error {
                Utilities.showErrorPopUp(labelContent: "Fehler", description: error.localizedDescription)
                finished(false)
            } else {
                let uid = Auth.auth().currentUser!.uid
                // set user status to logged-in
                if let defaults = UserDefaults(suiteName: UserDefaults.Keys.groupKey) {
                    defaults.setIsLoggedIn(value: true)
                    defaults.setUid(uid: uid)
                    defaults.synchronize()
                }
                finished(true) // sign-in process complete
            }
        }
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
    
    //MARK: checkIfAppleUserExists
    static func checkIfAppleUserExists(uid: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(uid)
        
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                completion(true)
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
}
