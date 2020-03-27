
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
