//
//  CustomClearButtonTextField.swift
//  Wishlist
//
//  Created by Christian Konnerth on 04.09.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit
import TextFieldEffects

class CustomTextField: HoshiTextField {

    
    //clear Button in Textfield
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 280, y: 30, width: 40, height: 20)
    }
    
    
    //Passwort vergessen Button positionieren
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let offset = -20
        let width  = 150
        let height = 124
        let x = Int(bounds.width) - width - offset
        let y = offset
        let rightViewBounds = CGRect(x: x, y: y, width: width, height: height)
        return rightViewBounds
    }
    
//    let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 23)
//
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
        
        /// the left padding
        @IBInspectable public var leftPadding: CGFloat = 0 { didSet { self.setNeedsLayout() } }
        
        /// the right padding
        @IBInspectable public var rightPadding: CGFloat = 0 { didSet { self.setNeedsLayout() } }
        
        /// Text rectangle
        ///
        /// - Parameter bounds: the bounds
        /// - Returns: the rectangle
        override public func textRect(forBounds bounds: CGRect) -> CGRect {
            let originalRect: CGRect = super.editingRect(forBounds: bounds)
            return CGRect(x: originalRect.origin.x + leftPadding, y: originalRect.origin.y, width: originalRect.size.width - leftPadding - rightPadding, height: originalRect.size.height)
        }
        
        /// Editing rectangle
        ///
        /// - Parameter bounds: the bounds
        /// - Returns: the rectangle
        override public func editingRect(forBounds bounds: CGRect) -> CGRect {
            let originalRect: CGRect = super.editingRect(forBounds: bounds)
            return CGRect(x: originalRect.origin.x + leftPadding, y: originalRect.origin.y, width: originalRect.size.width - leftPadding - rightPadding, height: originalRect.size.height)
        }
}
