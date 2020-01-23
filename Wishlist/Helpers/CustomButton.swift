//
//  CustomButton.swift
//  Wishlist
//
//  Created by Christian Konnerth on 20.01.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override open var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.9 : 1
        }
    }
}
