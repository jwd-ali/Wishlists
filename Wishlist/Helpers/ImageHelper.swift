//
//  ImageHelper.swift
//  Wishlists
//
//  Created by Christian Konnerth on 12.04.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

extension UIImage {

    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
//    func set(image: UIImage) {
//        let ratio = image.size.width / image.size.height
//        wishImageView.image = image
//        wishImageViewWidthConstraint.constant = ratio * wishImageViewHeight
//    }
    

    public var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
    
}


class ShadowRoundedImageView: UIView {
    @IBInspectable var image: UIImage? = nil {
        didSet {
            imageLayer.contents = image?.cgImage
            shadowLayer.shadowPath = (image == nil) ? nil : shapeAsPath }}

    var imageLayer: CALayer = CALayer()
    var shadowLayer: CALayer = CALayer()

    var shape: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius:3) }

    var shapeAsPath: CGPath {
        return shape.cgPath }

    var shapeAsMask: CAShapeLayer {
        let s = CAShapeLayer()
        s.path = shapeAsPath
        return s }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
        backgroundColor = .clear

        self.layer.addSublayer(shadowLayer)
        self.layer.addSublayer(imageLayer) // (in that order)

        imageLayer.frame = bounds
        imageLayer.contentsGravity = .resizeAspect // (as preferred)

        imageLayer.mask = shapeAsMask
        shadowLayer.shadowPath = (image == nil) ? nil : shapeAsPath

        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowColor = UIColor.darkCustom.cgColor
        shadowLayer.shadowRadius = 3
        shadowLayer.shadowOpacity = 0.80
    }
}
