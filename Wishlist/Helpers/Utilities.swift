//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()

        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 1)

        bottomLine.backgroundColor = UIColor.white.cgColor
        


        
        // Remove border on text field
        textfield.borderStyle = .none

        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)

    }
    
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        /*
        ^                         Start anchor
        (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
        (?=.*[!@#$&*])            Ensure string has one special case letter.
        (?=.*[0-9].*[0-9])        Ensure string has two digits.
        (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
        .{8}                      Ensure string is of length 8.
        $                         End anchor.
        */
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z]).(?=.*[0-9]).(?=.*[a-z]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    static func applyMotionEffect (toView view:UIView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
}

public extension UIView {

    func applyTransform(withScale scale: CGFloat, anchorPoint: CGPoint) {
        let xPadding = (scale - 1) * (anchorPoint.x - 0.5) * bounds.width
        let yPadding = (scale - 1) * (anchorPoint.y - 0.5) * bounds.height
        transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: xPadding, y: yPadding)
    }
}

public extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

