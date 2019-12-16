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
    
    let btn: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
    let wishlistImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.image = UIImage(named: "iconRoundedImage")
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        v.layer.shadowRadius = 3
        v.layer.shadowColor = UIColor.darkGray.cgColor
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
        contentView.addSubview(wishlistImage)
        contentView.addSubview(wishlistLabel)
        contentView.addSubview(btn)

        // constrain view to all 4 sides
        NSLayoutConstraint.activate([
            wishlistImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            wishlistImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wishlistImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wishlistImage.heightAnchor.constraint(equalToConstant:150),
           
            wishlistLabel.topAnchor.constraint(equalTo: wishlistImage.bottomAnchor,constant: 1),
            wishlistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            wishlistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wishlistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
 
 
