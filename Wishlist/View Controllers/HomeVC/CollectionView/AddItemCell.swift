//
//  AddItemCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 15.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

// MARK: Add WishList Cell
class AddItemCell: UICollectionViewCell {
 
    let btn: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitleColor(.darkGray, for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 40.0)
        return v
    }()
    
    let label: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "neue Wishlist erstellen"
        v.numberOfLines = 0
        v.font = UIFont(name: "AvenirNext-Regular", size: 20)
        v.textColor = .darkGray
        v.textAlignment = .center
        return v
    }()
    
    let plusLabel: UILabel = {
       let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "+"
        v.font = UIFont(name: "AvenirNext-Bold", size: 30)
        v.textColor = .white
        v.textAlignment = .center
        return v
    }()
 
    // this will be used as a "callback closure" in collection view controller
    var tapCallback: (() -> ())?
 
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
        contentView.addSubview(btn)
        contentView.addSubview(label)
        contentView.addSubview(plusLabel)
        

        // constrain button to all 4 sides
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: contentView.topAnchor),
            btn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            btn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            plusLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            plusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            plusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            plusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
        ])
        btn.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
 
    @objc func didTap(_ sender: Any) {
        // tell the collection view controller we got a button tap
        tapCallback?()
    }
 
}
