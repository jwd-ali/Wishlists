
//
//  ColorHelper.swift
//  Wishlists
//
//  Created by Christian Konnerth on 26.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit


enum ColorMode: String {
 case white
 case darkGray
    
  var create: UIColor {
     switch self {
        case .white:
          return UIColor.white
      case .darkGray:
          return UIColor.darkGray
     }
  }
}

extension UIColor {
    static let darkCustom = UIColor(red: 36.0/255.0, green: 37.0/255.0, blue: 39.0/255.0, alpha: 1.0)
    static let blueCustom = UIColor(red: 69.0/255.0, green: 111.0/255.0, blue: 126.0/255.0, alpha: 1.0)
}

struct Color: Codable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(uiColor: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    var uiColor: UIColor { UIColor(red: red, green: green, blue: blue, alpha: alpha) }
}
