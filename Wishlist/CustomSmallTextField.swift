//
//  CustomSmallTextField.swift
//  Wishlist
//
//  Created by Christian Konnerth on 09.10.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import TextFieldEffects

class CustomSmallTextField: HoshiTextField {

    //clear Button in Textfield
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 94, y: 30, width: 40, height: 20)
    }

}
