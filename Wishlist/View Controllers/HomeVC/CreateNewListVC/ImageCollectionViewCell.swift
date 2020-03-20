//
//  ImageCollectionViewCell.swift
//  Wishlist
//
//  Created by Christian Konnerth on 06.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    let cellImage: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
            setupViews()
       }
    
       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
    
    func setupViews(){
        contentView.addSubview(cellImage)
        
        cellImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
