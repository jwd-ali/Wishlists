//
//  Extensions.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 29.04.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

public extension UIImage {

    static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

}

public extension UIColor {
    static let darkCustom = UIColor(red: 31.0/255.0, green: 32.0/255.0, blue: 34.0/255.0, alpha: 1.0)
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
