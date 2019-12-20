//
//  CustomWishlistView.swift
//  Wishlist
//
//  Created by Christian Konnerth on 03.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class CustomWishlistView: UIView {

    
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
        v.setImage(UIImage(named: "dropdown"), for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(hideView), for: .touchUpInside)
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
    
    let wishCounterLabel: UILabel = {
        let v = UILabel()
        v.text = "5 unerfüllte Wünsche"
        v.font = UIFont(name: "AvenirNext", size: 12)
        v.textColor = .white
        v.font = v.font.withSize(12)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "iconRoundedImage")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add slideDown-gesture to WishlistView
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        self.addGestureRecognizer(slideDown)
        
        self.addSubview(dismissWishlistViewButton)
        self.addSubview(menueButton)
        self.addSubview(wishlistLabel)
        self.addSubview(wishlistImage)
        self.addSubview(wishCounterLabel)
        self.addSubview(theTableView.tableView)
        
        NSLayoutConstraint.activate([
            
            // constrain tableView
            theTableView.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 180.0),
            theTableView.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            theTableView.view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30.0),
            theTableView.view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30.0),
           
            // constrain dropDownButton
            dismissWishlistViewButton.topAnchor.constraint(equalTo: self.topAnchor),
            dismissWishlistViewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -650),
            dismissWishlistViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dismissWishlistViewButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -260),
            
            
            // constrain menueButton
            menueButton.topAnchor.constraint(equalTo: self.topAnchor),
            menueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -650),
            menueButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 260),
            menueButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // constrain wishlistImage
            wishlistImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -570),
            wishlistImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            wishlistImage.widthAnchor.constraint(equalToConstant: 80),
            wishlistImage.heightAnchor.constraint(equalToConstant: 80),
            
            //constrain wishlistlabel
            wishlistLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -600),
            wishlistLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 115),
            
            // constrain wishCounterLabel
            wishCounterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -585),
            wishCounterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 115),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // swipe down to dismiss
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        hideView()
    }
    
    @objc func hideView(){
        //animate welcomeLabel
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
    
        })
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            
            // hide wishlistView
            self.transform = CGAffineTransform(translationX: 0, y: 1000)
        })
    }
    
    @objc func menueButtonTapped(){
        print("menueButton tapped")
    }

}
