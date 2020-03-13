//
//  CustomCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 15.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Foundation
import UIKit
import Hero

// MARK: Simple Whishlist Cell
class ContentCell: UICollectionViewCell {
    
    let theView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let buttonView: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        v.layer.shadowRadius = 3
        v.layer.shadowColor = UIColor.darkGray.cgColor
        return v
    }()

   
    let cellLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Label"
        v.font = UIFont(name: "AvenirNext-Bold", size: 26)
        v.textColor = .white
        v.textAlignment = .left
        return v
    }()
    
    let wishCounterView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 57/255, alpha: 1)
        v.layer.cornerRadius = 30
        v.layer.maskedCorners = [ .layerMaxXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
        
    let wishCounterLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "0"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    let wünscheLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Wünsche"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    let priceView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 57/255, alpha: 1)
        v.layer.cornerRadius = 30
        v.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let priceLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "0.00"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    let priceEuroLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "€"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    
    
    
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.image = UIImage(named: "iconRoundedImage")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let imageView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(red: 50/255, green: 54/255, blue: 57/255, alpha: 1)
        v.layer.cornerRadius = 30
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
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
   
 
    func commonInit() -> Void {

        contentView.addSubview(cellLabel)
        contentView.addSubview(theView)
                
        theView.addSubview(imageView)
        imageView.addSubview(wishlistImage)
        
        theView.addSubview(wishCounterView)
        wishCounterView.addSubview(wishCounterLabel)
        wishCounterView.addSubview(wünscheLabel)

        theView.addSubview(priceView)
        priceView.addSubview(priceLabel)
        priceView.addSubview(priceEuroLabel)
        
        contentView.addSubview(buttonView)

        
//
        // constrain label to all 4 sides
        NSLayoutConstraint.activate([
            
            theView.topAnchor.constraint(equalTo: contentView.topAnchor),
            theView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            theView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            theView.heightAnchor.constraint(equalTo: contentView.heightAnchor),

            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
 
            cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            
            imageView.topAnchor.constraint(equalTo: cellLabel.bottomAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            wishlistImage.topAnchor.constraint(equalTo: imageView.topAnchor),
            wishlistImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            wishlistImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            wishlistImage.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            wishCounterView.topAnchor.constraint(equalTo: cellLabel.bottomAnchor),
            wishCounterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),
            wishCounterView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 7),
            wishCounterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            wishCounterLabel.centerXAnchor.constraint(equalTo: wishCounterView.centerXAnchor),
            wishCounterLabel.centerYAnchor.constraint(equalTo: wishCounterView.centerYAnchor, constant: -5),
            
            wünscheLabel.centerXAnchor.constraint(equalTo: wishCounterView.centerXAnchor),
            wünscheLabel.centerYAnchor.constraint(equalTo: wishCounterView.centerYAnchor, constant: 15),
            
            priceView.topAnchor.constraint(equalTo: wishCounterView.bottomAnchor, constant: 7),
            priceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            priceView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 7),
            priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            priceLabel.centerXAnchor.constraint(equalTo: priceView.centerXAnchor, constant: 3),
            priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
    
            priceEuroLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 2),
            priceEuroLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor, constant: 1),
        ])
        buttonView.addTarget(self, action: #selector(customWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var customWishlistTapCallback: (() -> ())?
       
       @objc func customWishlistTapped(_ sender: Any) {
           // tell the collection view controller we got a button tap
            customWishlistTapCallback?()
       }
}
