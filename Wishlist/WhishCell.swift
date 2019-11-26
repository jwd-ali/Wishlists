//
//  WhishCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class WhishCell: UITableViewCell {
    
    let label: UILabel = {
       let v = UILabel()
        v.font = UIFont(name: "AvenirNext", size: 23)
        v.textColor = .white
        v.font = v.font.withSize(23)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
        let checkButton: UIButton =  {
        let v = UIButton()
        v.backgroundColor = .darkGray
//        v.layer.borderColor = UIColor.red.cgColor
//        v.layer.borderWidth = 2.0
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setBackgroundImage(UIImage(named: "boxUnchecked"), for: .normal)
        
        return v
    }()
    
    
    
    public static let reuseID = "WhishCell"

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        // add checkButton
        self.contentView.addSubview(checkButton)
        self.checkButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.checkButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.checkButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        // add label
        self.contentView.addSubview(label)
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
    }
    
    @objc func checkButtonTapped(){
        self.checkButton.setBackgroundImage(UIImage(named: "boxChecked"), for: .normal)
        self.checkButton.alpha = 0
        self.checkButton.transform =  CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.3) {
            self.checkButton.alpha = 1
            self.checkButton.transform = CGAffineTransform.identity
        }
    }
}
