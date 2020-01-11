//
//  DropDownCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 16.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class DropDownCell: UITableViewCell {

    public static let reuseID = "DropDownCell"
    
    let label: UILabel = {
       let v = UILabel()
        v.font = UIFont(name: "AvenirNext", size: 17)
        v.textColor = .white
        v.font = v.font.withSize(17)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let listImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .lightGray
        
        // add image
        self.contentView.addSubview(listImage)
        self.listImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        self.listImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.listImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.listImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        // add label
        self.contentView.addSubview(label)
        self.label.leadingAnchor.constraint(equalTo: self.listImage.leadingAnchor, constant: 35).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

}
