
//
//  ColorHelper.swift
//  Wishlists
//
//  Created by Christian Konnerth on 26.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit


enum Color: String {
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
    
    static let darkCustom = UIColor(red: 31.0/255.0, green: 32.0/255.0, blue: 34.0/255.0, alpha: 1.0)
}
