//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

class Utilities {
    
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
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$")
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
    
    
    //MARK: Error Pop-up
    static func showErrorPopUp(labelContent: String, description: String){
        var attributes = EKAttributes.topToast
        attributes.entryBackground = .color(color: EKColor(.white))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.displayDuration = 4

        let title = EKProperty.LabelContent(text: labelContent, style: .init(font: UIFont(name: "AvenirNext-Bold", size: 15)!, color: EKColor(UIColor.darkGray)))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont(name: "AvenirNext-Regular", size: 13)!, color: EKColor(UIColor.darkGray)))
        let image = EKProperty.ImageContent(image: UIImage(named: "false")!, size: CGSize(width: 20, height: 20))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        

        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    //MARK: getHTMLfromURL
    static func getHTMLfromURL(url: String) -> String{
        let myURLString = url
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }

        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
            return myHTMLString
        } catch let error {
            print("Error: \(error)")
        }
        
        return ""
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

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
}

extension UIStackView {
    func addBackgroundColorWithTopCornerRadius(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = 10
        subView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        insertSubview(subView, at: 0)
    }
}

