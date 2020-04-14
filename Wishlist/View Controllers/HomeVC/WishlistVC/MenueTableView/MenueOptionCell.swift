//
//  ListSettingCell.swift
//  Wishlists
//
//  Created by Christian Konnerth on 25.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

class MenueOptionCell: UITableViewCell {

    public static let reuseID = "MenueOptionCell"
    
    lazy var theTitle: UILabel = {
       let v = UILabel()
        v.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        v.textColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var theImage: UIImageView = {
        let v = UIImageView()
        v.image = v.image?.withRenderingMode(.alwaysTemplate)
        v.tintColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .darkCustom
        
        // add image
        self.contentView.addSubview(theImage)
        self.theImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        self.theImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.theImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.theImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // add label
        self.contentView.addSubview(theTitle)
        self.theTitle.leadingAnchor.constraint(equalTo: self.theImage.leadingAnchor, constant: 50).isActive = true
        self.theTitle.centerYAnchor.constraint(equalTo: theImage.centerYAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

}
