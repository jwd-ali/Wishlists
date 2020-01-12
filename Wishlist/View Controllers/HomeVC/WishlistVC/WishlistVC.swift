//
//  WishlistViewController.swift
//  Wishlist
//
//  Created by Christian Konnerth on 27.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import Hero

// DonMag3 - protocol / delegate pattern
// allows wish table view (and cell) to update wish list data
protocol DeleteWishDelegate {
    func deleteWish(_ idx: Int)
}

// allow MainVC to recieve updated datasource array
protocol DismissWishlistDelegate {
    func dismissWishlistVC(dataArray: [Wishlist])
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
       v.view.backgroundColor = .clear
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
    
    let makeWishView: MakeWishView = {
        let v = MakeWishView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // track the current selected wish list
    var currentWishListIDX: Int = 0
    
    // track current listImageIdx
    var currentImageArrayIDX: Int?
    
    // track Wishlist IDX -> start at one so Firestore sorting works properly
    var wishlistIDX: Int = 1
    
    // track selected wishlist in dropDownView
    var selectedWishlistIDX: Int?
    
    // create wishlist
    var wishList: Wishlist!
    
    var theDropDownOptions: [String]!
    
    var theDropDownImageOptions: [UIImage]!
    
    var dataSourceArray = [Wishlist]()
    
    var dismissWishDelegate: DismissWishlistDelegate?
    
    // panGestureRecognizer for interactive gesture dismiss
    var panGR: UIPanGestureRecognizer!


    //        // make dismiss button fade away to the top
    //        self.dismissWishlistViewButton.hero.isEnabled = true
    //        self.dismissWishlistViewButton.heroID = "dismissButton"
    //        self.dismissWishlistViewButton.hero.modifiers = [.fade, .translate(CGPoint(x: 0, y: -150), z: 20)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wishlistBackgroundView.hero.isEnabled = true
        self.wishlistBackgroundView.heroID = "wishlistView"
        
        self.wishlistBackgroundView.hero.modifiers = [.fade, .translate(CGPoint(x: 0, y: 800), z: 20)]
        
        

        
        // adding panGestureRecognizer
        panGR = UIPanGestureRecognizer(target: self,
                  action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGR)
        
        self.wishlistLabel.text = wishList.name
        self.wishlistImage.image = wishList.image
        self.theTableView.wishList = wishList.wishData
        self.theTableView.tableView.reloadData()
        
        
        view.addSubview(wishlistBackgroundView)
        view.addSubview(dismissWishlistViewButton)
        view.addSubview(menueButton)
        wishlistBackgroundView.addSubview(wishlistView)
        wishlistBackgroundView.addSubview(wishlistLabel)
        wishlistBackgroundView.addSubview(wishlistImage)
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
    
    // define a small helper function to add two CGPoints
    func addCGPoints (left: CGPoint, right: CGPoint) -> CGPoint {
      return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    // handle swqipe down gesture
    @objc private func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
        
        // calculate the progress based on how far the user moved
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
      switch panGR.state {
      case .began:
        // begin the transition as normal
        dismiss(animated: true, completion: nil)
      case .changed:
        
        Hero.shared.update(progress)
        
        // update views' position based on the translation
        let viewPosition = CGPoint(x: wishlistBackgroundView.center.x, y: translation.y + wishlistBackgroundView.center.y)
            
        Hero.shared.apply(modifiers: [.position(viewPosition)], to: self.wishlistBackgroundView)
        
        
      default:
        // finish or cancel the transition based on the progress and user's touch velocity
           if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
             Hero.shared.finish()
           } else {
             Hero.shared.cancel()
           }
      }
    }
    
    @objc private func menueButtonTapped(){
        print("menueButtonTapped")
    }
    
    @objc private func dismissView(){
        //  update datasource array in MainVC
        self.dismissWishDelegate?.dismissWishlistVC(dataArray: self.dataSourceArray)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addWishButtonTapped(){
        
        view.addSubview(makeWishView)
        
        makeWishView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        makeWishView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        makeWishView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        makeWishView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        makeWishView.grayView.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
        makeWishView.visualEffectView.alpha = 0
        makeWishView.grayView.alpha = 0
        makeWishView.wishButton.alpha = 0
        makeWishView.closeButton.alpha = 0
        makeWishView.dropDownButton.alpha = 0
        makeWishView.wishNameTextField.alpha = 0
        makeWishView.wishImage.alpha = 0
        makeWishView.wishImageButton.alpha = 0
        makeWishView.linkTextField.alpha = 0
        makeWishView.priceTextField.alpha = 0
        makeWishView.noteTextField.alpha = 0
        makeWishView.linkImage.alpha = 0
        makeWishView.priceImage.alpha = 0
        makeWishView.noteImage.alpha = 0
        
        makeWishView.addWishDelegate = self
        
        // set dropDownOptions
        makeWishView.dropDownButton.dropView.dropDownOptions = self.theDropDownOptions
        makeWishView.dropDownButton.dropView.dropDownListImages = self.theDropDownImageOptions
        
        // set dropDownButton image and label to current wishlists image and label
        makeWishView.dropDownButton.listImage.image = self.wishlistImage.image
        makeWishView.dropDownButton.label.text = self.wishlistLabel.text
        
        // pass data array
        makeWishView.dataSourceArray = self.dataSourceArray
        
        // update selectedWishlistIDX
        makeWishView.selectedWishlistIDX = currentWishListIDX
        
        // reset textfield 
        makeWishView.wishNameTextField.text = ""
        makeWishView.wishNameTextField.becomeFirstResponder()        
            
        UIView.animate(withDuration: 0.3) {
            
            self.makeWishView.visualEffectView.alpha = 1
            self.makeWishView.grayView.alpha = 1
            self.makeWishView.wishButton.alpha = 1
            self.makeWishView.closeButton.alpha = 1
            self.makeWishView.dropDownButton.alpha = 1
            self.makeWishView.wishNameTextField.alpha = 1
            self.makeWishView.wishImage.alpha = 1
            self.makeWishView.wishImageButton.alpha = 1
            self.makeWishView.linkTextField.alpha = 1
            self.makeWishView.priceTextField.alpha = 1
            self.makeWishView.noteTextField.alpha = 1
            self.makeWishView.linkImage.alpha = 1
            self.makeWishView.priceImage.alpha = 1
            self.makeWishView.noteImage.alpha = 1
            
            self.makeWishView.grayView.transform = CGAffineTransform.identity
        }
        
        
    }
    
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

extension WishlistViewController: AddWishDelegate {
    func addWishComplete(wishName: String?, selectedWishlistIDX: Int?) {
        
        self.dataSourceArray[selectedWishlistIDX!].wishData.append(Wish(withWishName: wishName!, checked: false))
        
        // only update current list if selectedWishlist is currentWishlist
        if selectedWishlistIDX == currentWishListIDX {
            wishList.wishData.append(Wish(withWishName: wishName!, checked: false))
            theTableView.wishList = wishList.wishData
            print(wishName!)
            self.theTableView.tableView.reloadData()
        }
        
    }
}
