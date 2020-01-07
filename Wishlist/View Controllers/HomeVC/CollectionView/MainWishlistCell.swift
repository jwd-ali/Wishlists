//
//  MainWishlistCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 15.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

// MARK: Main Wishlist cell
class MainWishlistCell: UICollectionViewCell {
    
    let wishCounterView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 50, green: 54, blue: 57, alpha: 1)
        v.layer.cornerRadius = 30
        v.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        return v
    }()
    
    let wishCounterLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "0"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    let wünscheLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Wünsche"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .lightGray
        v.textAlignment = .center
        return v
    }()
    
    let priceView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 50, green: 54, blue: 57, alpha: 1)
        v.layer.cornerRadius = 30
        v.layer.maskedCorners = [ .layerMaxXMinYCorner]
        return v
    }()
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "0.00"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    let priceEuroLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "€"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .lightGray
        v.textAlignment = .center
        return v
    }()
    
    
    
    
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "iconRoundedImage")
//        v.layer.shadowOpacity = 1
//        v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
//        v.layer.shadowRadius = 3
//        v.layer.shadowColor = UIColor.darkGray.cgColor
        return v
    }()
    
    let imageView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 50, green: 54, blue: 57, alpha: 1)
        v.layer.cornerRadius = 30
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    let btn: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
    let wishlistLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Main Wishlist"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        v.textColor = .darkGray
        v.textAlignment = .center
        return v
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
    override func layoutSubviews() {
       super.layoutSubviews()
    }
   
    func commonInit() -> Void {
        contentView.addSubview(imageView)
        imageView.addSubview(wishlistImage)
        
        contentView.addSubview(wishCounterView)
        wishCounterView.addSubview(wishCounterLabel)
        wishCounterView.addSubview(wünscheLabel)
        
        contentView.addSubview(priceView)
        priceView.addSubview(priceLabel)
        priceView.addSubview(priceEuroLabel)
        
        contentView.addSubview(wishlistLabel)
        contentView.addSubview(btn)

        // constrain view to all 4 sides
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            wishlistImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            wishlistImage.centerYAnchor.constraint(equalTo: centerYAnchor),
           
            wishlistLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            wishlistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            
            
            btn.topAnchor.constraint(equalTo: contentView.topAnchor),
            btn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
       btn.addTarget(self, action: #selector(mainWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var wishlistTapCallback: (() -> ())?
    
    @objc func mainWishlistTapped(_ sender: Any) {
        // tell the collection view controller we got a button tap
        wishlistTapCallback?()
    }
}
 
 
