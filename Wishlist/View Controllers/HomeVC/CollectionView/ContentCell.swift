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

        let screenWidth = UIScreen.main.bounds.width
        let fontSizeAdjustment = screenWidth / 414.0
        cellLabel.font = UIFont(name: "AvenirNext-Bold", size: (26.0 * fontSizeAdjustment))
        wishCounterLabel.font = UIFont(name: "AvenirNext-DemiBold", size: (15.0 * fontSizeAdjustment))
        priceLabel.font = UIFont(name: "AvenirNext-DemiBold", size: (15.0 * fontSizeAdjustment))


        contentView.addSubview(theView)

        // add cellLabel, imageView, wishCounterView, priceView
        //  all to theView
        theView.addSubview(cellLabel)
        theView.addSubview(imageView)
        theView.addSubview(wishCounterView)
        theView.addSubview(priceView)

        // add subviews
        imageView.addSubview(wishlistImage)
        wishCounterView.addSubview(wishCounterLabel)
        priceView.addSubview(priceLabel)

        contentView.addSubview(buttonView)

        // prevent the label from expanding or compressig vertically
        cellLabel.setContentHuggingPriority(.required, for: .vertical)
        cellLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        NSLayoutConstraint.activate([

           // theView
           //  all 4 sides to contentView
           theView.topAnchor.constraint(equalTo: contentView.topAnchor),
           theView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           theView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           theView.heightAnchor.constraint(equalTo: contentView.heightAnchor),

           // cellLabel
           //  Top / Leading / Trailing to theView
           cellLabel.topAnchor.constraint(equalTo: theView.topAnchor),
           cellLabel.leadingAnchor.constraint(equalTo: theView.leadingAnchor),
           cellLabel.trailingAnchor.constraint(equalTo: theView.trailingAnchor),
          
           // imageView
           //  Top to cellLabel bottom
           //  Leading & Bottom to theView
           //  Width: theView width -100
           imageView.topAnchor.constraint(equalTo: cellLabel.bottomAnchor),
           imageView.bottomAnchor.constraint(equalTo: theView.bottomAnchor),
           imageView.leadingAnchor.constraint(equalTo: theView.leadingAnchor),
           imageView.widthAnchor.constraint(equalTo: theView.widthAnchor, constant: -100),

           // wishlistImage
           //  Top / Bottom to imageView
           //  centerX
           wishlistImage.topAnchor.constraint(equalTo: imageView.topAnchor),
           wishlistImage.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
           wishlistImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),

           // wishCounterView
           //  Top to imageView
           //  Leading to imageView Trailing + spacing
           //  Trailing to theView
           wishCounterView.topAnchor.constraint(equalTo: imageView.topAnchor),
           wishCounterView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacingBetweenViews),
           wishCounterView.trailingAnchor.constraint(equalTo: theView.trailingAnchor),

           // priceView
           //  Leading to imageView Trailing + spacing
           //  Trailing to theView
           //  Bottom to theView
           priceView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacingBetweenViews),
           priceView.trailingAnchor.constraint(equalTo: theView.trailingAnchor),
           priceView.bottomAnchor.constraint(equalTo: theView.bottomAnchor),
          
           // wishCounterView
           //  Height = imageView Height * 0.5 -(spacing * 0.5)
           wishCounterView.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.5, constant: -(spacingBetweenViews * 0.5)),

           // priceView
           //  Height = wishCounterView Height
           priceView.heightAnchor.constraint(equalTo: wishCounterView.heightAnchor),

           // wishCounterLabel
           //  centered X & Y
           wishCounterLabel.centerXAnchor.constraint(equalTo: wishCounterView.centerXAnchor),
           wishCounterLabel.centerYAnchor.constraint(equalTo: wishCounterView.centerYAnchor),

           // priceLabel
           //  centered X & Y
           priceLabel.centerXAnchor.constraint(equalTo: priceView.centerXAnchor),
           priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
           
           // buttonView
           // all 4 sides to contentView
           buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
           buttonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           buttonView.heightAnchor.constraint(equalTo: contentView.heightAnchor),

        ])

        buttonView.addTarget(self, action: #selector(customWishlistTapped(_:)), for: .touchUpInside)
       }
    
    var customWishlistTapCallback: (() -> ())?
       
       @objc func customWishlistTapped(_ sender: Any) {
           // tell the collection view controller we got a button tap
            customWishlistTapCallback?()
       }
}
