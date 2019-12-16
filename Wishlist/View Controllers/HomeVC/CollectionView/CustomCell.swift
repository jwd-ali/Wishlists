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
   
    let testLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Test Label"
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
   
 
    func commonInit() -> Void {

        contentView.layer.cornerRadius = 3.0;
        contentView.addSubview(testLabel)
        contentView.addSubview(buttonView)
        // constrain label to all 4 sides
        NSLayoutConstraint.activate([

            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonView.heightAnchor.constraint(equalToConstant:150),
 
            testLabel.topAnchor.constraint(equalTo: buttonView.bottomAnchor,constant: 1),
            testLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            testLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        buttonView.addTarget(self, action: #selector(customWishlistTapped(_:)), for: .touchUpInside)
    }
    
    var customWishlistTapCallback: (() -> ())?
       
       @objc func customWishlistTapped(_ sender: Any) {
           // tell the collection view controller we got a button tap
            customWishlistTapCallback?()
       }
}
