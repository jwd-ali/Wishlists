//
//  AlignedAspectFitImageViewHelper.swift
//  Wishlists
//
//  Created by Christian Konnerth on 10.04.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AlignedAspectFitImageView: UIView {

    enum HorizontalAlignment: String {
        case left, center, right
    }

    enum VerticalAlignment: String {
        case top, center, bottom
    }

    private var theImageView: UIImageView = {
        let v = UIImageView()
        return v
    }()

    @IBInspectable var image: UIImage? {
        get { return theImageView.image }
        set {
            theImageView.image = newValue
            setNeedsLayout()
        }
    }

    @IBInspectable var hAlign: String = "center" {
        willSet {
            // Ensure user enters a valid alignment name while making it lowercase.
            if let newAlign = HorizontalAlignment(rawValue: newValue.lowercased()) {
                horizontalAlignment = newAlign
            }
        }
    }

    @IBInspectable var vAlign: String = "center" {
        willSet {
            // Ensure user enters a valid alignment name while making it lowercase.
            if let newAlign = VerticalAlignment(rawValue: newValue.lowercased()) {
                verticalAlignment = newAlign
            }
        }
    }

    var horizontalAlignment: HorizontalAlignment = .center
    var verticalAlignment: VerticalAlignment = .center

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() -> Void {
        addSubview(theImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let img = theImageView.image else {
            return
        }

        var newRect = bounds

        let viewRatio = bounds.size.width / bounds.size.height
        let imgRatio = img.size.width / img.size.height

        // if view ratio is equal to image ratio, we can fill the frame
        if viewRatio == imgRatio {
            theImageView.frame = newRect
            return
        }

        // otherwise, calculate the desired frame

        if imgRatio < 1.0 {
            // image is taller than wide
            let heightFactor = bounds.size.height / img.size.height
            let w = img.size.width * heightFactor
            newRect.size.width = w
            switch horizontalAlignment {
            case .center:
                newRect.origin.x = (bounds.size.width - w) * 0.5
            case .right:
                newRect.origin.x = bounds.size.width - w
            default: break  // left align - no changes needed
            }
        } else {
            // image is wider than tall
            let widthFactor = bounds.size.width / img.size.width
            let h = img.size.height * widthFactor
            newRect.size.height = h
            switch verticalAlignment {
            case .center:
                newRect.origin.y = (bounds.size.height - h) * 0.5
            case .bottom:
                newRect.origin.y = bounds.size.height - h
            default: break  // top align - no changes needed
            }
        }

        theImageView.frame = newRect
    }
}
