//
//  CustomCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 15.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

// MARK: Simple Whishlist Cell
class ContentCell: UICollectionViewCell {
    
    let buttonView: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        v.layer.shadowRadius = 3
        v.layer.shadowColor = UIColor.darkGray.cgColor
        return v
    }()
     
    let theLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        return v
    }()
   
    let cellLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Test Label"
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        v.textColor = .darkGray
        v.textAlignment = .center
        return v
    }()
    
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
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
   
 
    func commonInit() -> Void {

        contentView.layer.cornerRadius = 3.0;
        contentView.addSubview(cellLabel)
        contentView.addSubview(buttonView)
        // constrain label to all 4 sides
        NSLayoutConstraint.activate([

            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant:150),
 
            cellLabel.topAnchor.constraint(equalTo: buttonView.bottomAnchor,constant: 1),
            cellLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        buttonView.addTarget(self, action: #selector(customWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var customWishlistTapCallback: (() -> ())?
       
       @objc func customWishlistTapped(_ sender: Any) {
           // tell the collection view controller we got a button tap
            customWishlistTapCallback?()
       }
}
