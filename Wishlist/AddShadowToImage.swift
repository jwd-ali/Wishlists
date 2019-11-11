//
//  AddShadowToImage.swift
//  Wishlist
//
//  Created by Christian Konnerth on 03.11.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Swift
import Foundation
import UIKit

extension UIImageView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float)
    {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
}
