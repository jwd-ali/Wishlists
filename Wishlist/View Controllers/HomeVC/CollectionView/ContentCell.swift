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

// MARK: ContentCell
class ContentCell: UICollectionViewCell {
    
    public static let reuseID = "ContentCell"
    
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
        v.minimumScaleFactor = 0.5
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
        v.text = "0\n Wünsche"
        v.numberOfLines = 2
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
        v.text = "0.00€"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
    
    
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
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
        
        let spacingBetweenViews = CGFloat(7)
        
        contentView.addSubview(cellLabel)
        contentView.addSubview(theView)
                
        theView.addSubview(imageView)
        imageView.addSubview(wishlistImage)
        
        theView.addSubview(wishCounterView)
        wishCounterView.addSubview(wishCounterLabel)
//        wishCounterView.addSubview(wünscheLabel)

        theView.addSubview(priceView)
        priceView.addSubview(priceLabel)
        
        contentView.addSubview(buttonView)

        
        theView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        theView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        theView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        theView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true

        buttonView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true

        cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let labelHeight = cellLabel.heightAnchor.constraint(equalToConstant: 20)
        labelHeight.isActive = true
        
        imageView.topAnchor.constraint(equalTo: cellLabel.bottomAnchor, constant:  8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        
        
        wishlistImage.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        wishlistImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        wishlistImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        wishlistImage.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let contentViewHeight = self.frame.size.height
        print(contentViewHeight)
        wishCounterView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        wishCounterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentViewHeight - labelHeight.constant) / 2).isActive = true
        wishCounterView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacingBetweenViews).isActive = true
        wishCounterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        wishCounterLabel.topAnchor.constraint(equalTo: wishCounterView.topAnchor).isActive = true
        wishCounterLabel.leadingAnchor.constraint(equalTo: wishCounterView.leadingAnchor).isActive = true
        wishCounterLabel.trailingAnchor.constraint(equalTo: wishCounterView.trailingAnchor).isActive = true
        wishCounterLabel.bottomAnchor.constraint(equalTo: wishCounterView.bottomAnchor).isActive = true
        
        
        priceView.topAnchor.constraint(equalTo: wishCounterView.bottomAnchor, constant: spacingBetweenViews).isActive = true
        priceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        priceView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacingBetweenViews).isActive = true
        priceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: priceView.bottomAnchor).isActive = true
        
        
        buttonView.addTarget(self, action: #selector(customWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var customWishlistTapCallback: (() -> ())?
       
       @objc func customWishlistTapped(_ sender: Any) {
           // tell the collection view controller we got a button tap
            customWishlistTapCallback?()
       }
}
