//
//  WishlistViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 27.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

// DonMag3 - protocol / delegate pattern
// allows wish table view (and cell) to update wish list data
protocol DeleteWishDelegate {
    func deleteWish(_ idx: Int)
}


//// recieve data from MainVC to insert wish
//protocol InsertWishDelegate {
//    func insertWish(wishName: String, idx: Int, currentWishlistIDX: Int, data: Wishlist)
//}

class WishlistViewController: UIViewController, DeleteWishDelegate{

    
    let wishlistBackgroundView: UIView = {
           let v = UIView()
           v.translatesAutoresizingMaskIntoConstraints = false
           v.backgroundColor = .gray
           return v
       }()
       
   let wishlistView: UIView = {
       let v = UIView()
       v.translatesAutoresizingMaskIntoConstraints = false
       v.backgroundColor = .darkGray
       v.layer.cornerRadius = 30
       v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
       return v
   }()
   
   lazy var theTableView: WhishlistTableViewController = {
      let v = WhishlistTableViewController()
       v.view.layer.masksToBounds = true
//       v.view.layer.borderColor = UIColor.white.cgColor
       v.view.backgroundColor = .clear
//       v.view.layer.borderWidth = 7.0
       v.view.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   let dismissWishlistViewButton: UIButton = {
       let v = UIButton()
       v.setImage(UIImage(named: "dismissButton"), for: .normal)
       v.translatesAutoresizingMaskIntoConstraints = false
       v.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
       return v
   }()
   
   let menueButton: UIButton = {
       let v = UIButton()
       v.setImage(UIImage(named: "menueButton"), for: .normal)
       v.translatesAutoresizingMaskIntoConstraints = false
       v.addTarget(self, action: #selector(menueButtonTapped), for: .touchUpInside)
       return v
   }()
   
   let wishlistLabel: UILabel = {
       let v = UILabel()
       v.text = "Wishlist"
       v.font = UIFont(name: "AvenirNext-Bold", size: 35)
       v.textColor = .white
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   let wishlistImage: UIImageView = {
       let v = UIImageView()
       v.image = UIImage(named: "iconRoundedImage")
       v.layer.shadowOpacity = 1
       v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
       v.layer.shadowRadius = 3
       v.layer.shadowColor = UIColor.darkGray.cgColor
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
    
    let addWishButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "addButton"), for: .normal)
        v.addTarget(self, action: #selector(addWishButtonTapped), for: .touchUpInside)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
//    // array of wish lists
//    // this will eventually be managed by some type of data handler class
//    var userWishListData: [[Wish]] = [[Wish]]()
    
    // DonMag3 - track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // track current listImageIdx
    var currentImageArrayIDX: Int?
    
    // track Wishlist IDX -> start at one so Firestore sorting works properly
    var wishlistIDX: Int = 1
    
    var selectedWishlistIDX: Int?
    
    var wishList: Wishlist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wishlistLabel.text = wishList.name
        self.wishlistImage.image = wishList.image
        self.theTableView.wishList = wishList.wishData
        self.theTableView.tableView.reloadData()
        
        
        view.addSubview(wishlistBackgroundView)
        view.addSubview(dismissWishlistViewButton)
        view.addSubview(menueButton)
        wishlistBackgroundView.addSubview(wishlistView)
        wishlistView.addSubview(wishlistLabel)
        wishlistView.addSubview(wishlistImage)
        wishlistView.addSubview(theTableView.tableView)
        wishlistView.addSubview(addWishButton)
        
        NSLayoutConstraint.activate([
            
            
            // constrain wishlistView
            wishlistBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            wishlistBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wishlistBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            wishlistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160.0),
            wishlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            wishlistView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            wishlistView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            // constrain wishTableView
            theTableView.view.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 60.0),
            theTableView.view.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: 0),
            theTableView.view.leadingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theTableView.view.trailingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
           
            // constrain dismissButton
            dismissWishlistViewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissWishlistViewButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 23.0),
            
            // constrain menueButton
            menueButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            menueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25.0),
            
            // constrain wishlistImage
            wishlistImage.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: -70),
            wishlistImage.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor, constant: 30),
            wishlistImage.widthAnchor.constraint(equalToConstant: 90),
            wishlistImage.heightAnchor.constraint(equalToConstant: 90),
            
            //constrain wishlistlabel
            wishlistLabel.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: -47),
            wishlistLabel.leadingAnchor.constraint(equalTo: wishlistImage.leadingAnchor, constant: 100),
            
            addWishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addWishButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
        ])
        
        // set DeleteWishDelegate protocol for the table
        theTableView.deleteWishDelegate = self
        
    
    }
    
    @objc private func menueButtonTapped(){
        print("menueButtonTapped")
    }
    
    @objc private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addWishButtonTapped(){
        print("addWishButton tapped")
    }
    
//    func insertWish(wishName: String, idx: Int, currentWishlistIDX: Int, data: Wishlist) {
//        print(wishName)
//
//        var wList = data
//        // append the new wish to the user's currently selected wishlist
//        wList.wishData.append(Wish(withWishName: wishName, checked: false))
//        // set the updated data as the data for the table view
//        theTableView.wishList = wishList.wishData
//        theTableView.tableView.reloadData()
//    }
    
    func deleteWish(_ idx: Int){
        // DonMag3 - remove the wish from the user's currently selected wishlist
        var wishes: [Wish] = wishList.wishData
        wishes.remove(at: idx)
        wishList.wishData = wishes
        // set the updated data as the data for the table view
        theTableView.wishList = wishList.wishData
        theTableView.tableView.reloadData()
    }
}
