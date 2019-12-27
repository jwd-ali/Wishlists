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

class WishlistViewController: UIViewController, DeleteWishDelegate {
    
    
    let wishlistBackgroundView: UIView = {
           let v = UIView()
           v.translatesAutoresizingMaskIntoConstraints = false
           v.backgroundColor = .darkGray
           return v
       }()
       
   let wishlistView: UIView = {
       let v = UIView()
       v.translatesAutoresizingMaskIntoConstraints = false
       v.backgroundColor = .gray
       v.layer.cornerRadius = 30
       return v
   }()
   
   lazy var theTableView: WhishlistTableViewController = {
      let v = WhishlistTableViewController()
       v.view.layer.masksToBounds = true
       v.view.layer.borderColor = UIColor.white.cgColor
       v.view.backgroundColor = .clear
       v.view.layer.borderWidth = 7.0
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
       v.text = "Main Wishlist"
       v.font = UIFont(name: "AvenirNext-Bold", size: 30)
       v.textColor = .white
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   let wishlistImage: UIImageView = {
       let v = UIImageView()
       v.image = UIImage(named: "iconRoundedImage")
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
    
    // array of wish lists
    // this will eventually be managed by some type of data handler class
    var userWishListData: [[Wish]] = [[Wish]]()
    
    // DonMag3 - track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // track current listImageIdx
    var currentImageArrayIDX: Int?
    
    // track Wishlist IDX -> start at one so Firestore sorting works properly
    var wishlistIDX: Int = 1
    
    var selectedWishlistIDX: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(wishlistBackgroundView)
        wishlistBackgroundView.addSubview(wishlistView)
        wishlistView.addSubview(dismissWishlistViewButton)
        wishlistView.addSubview(menueButton)
        wishlistView.addSubview(wishlistLabel)
        wishlistView.addSubview(wishlistImage)
        wishlistView.addSubview(theTableView.tableView)
        
        NSLayoutConstraint.activate([
            
            
            // constrain wishlistView
            wishlistBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            wishlistBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wishlistBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            wishlistView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120.0),
            wishlistView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            wishlistView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            wishlistView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            // constrain wishTableView
            theTableView.view.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 180.0),
            theTableView.view.bottomAnchor.constraint(equalTo: wishlistView.bottomAnchor, constant: 0),
            theTableView.view.leadingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theTableView.view.trailingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
           
            // constrain dismissButton
            dismissWishlistViewButton.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 20),
            dismissWishlistViewButton.leadingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.leadingAnchor, constant: 23.0),
            
            // constrain menueButton
            menueButton.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 20),
            menueButton.trailingAnchor.constraint(equalTo: wishlistView.safeAreaLayoutGuide.trailingAnchor, constant: -25.0),
            
            // constrain wishlistImage
            wishlistImage.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 83),
            wishlistImage.leadingAnchor.constraint(equalTo: wishlistView.leadingAnchor, constant: 30),
            wishlistImage.widthAnchor.constraint(equalToConstant: 80),
            wishlistImage.heightAnchor.constraint(equalToConstant: 80),
            
            //constrain wishlistlabel
            wishlistLabel.topAnchor.constraint(equalTo: wishlistView.topAnchor, constant: 98),
            wishlistLabel.leadingAnchor.constraint(equalTo: wishlistImage.leadingAnchor, constant: 93),
            
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
    
    func deleteWish(_ idx: Int){
        // DonMag3 - remove the wish from the user's currently selected wishlist
        var wishes: [Wish] = userWishListData[currentWishListIDX]
        wishes.remove(at: idx)
        userWishListData[currentWishListIDX] = wishes
        // set the updated data as the data for the table view
        theTableView.wishList = userWishListData[currentWishListIDX]
        theTableView.tableView.reloadData()
    }
}
