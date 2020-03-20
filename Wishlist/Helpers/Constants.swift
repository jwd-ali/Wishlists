//
//  Constants.swift
//  Wishlist
//
//  Created by Christian Konnerth on 22.08.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
    }
    
    struct ImageList {
        static let images: [UIImage] = [
            UIImage(named: "avocadoImage")!,
            UIImage(named: "beerImage")!,
            UIImage(named: "bikeImage")!,
            UIImage(named: "christmasImage")!,
            UIImage(named: "dressImage")!,
            UIImage(named: "giftImage")!,
//            UIImage(named: "goalImage")!,
            UIImage(named: "rollerImage")!,
            UIImage(named: "shirtImage")!,
            UIImage(named: "shoeImage")!,
            UIImage(named: "travelImage")!,
        ]
        
        static let customColors: [UIColor] = [
            UIColor(red: 215/255, green: 155/255, blue: 131/255, alpha: 1), // avocado
            UIColor(red: 0/255, green: 76/255, blue: 98/255, alpha: 1),     // beer
            UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1), // bike
            UIColor(red: 255/255, green: 255/255, blue: 235/255, alpha: 1), // christmas
            UIColor(red: 238/255, green: 196/255, blue: 199/255, alpha: 1), // dress
            UIColor(red: 93/255, green: 101/255, blue: 120/255, alpha: 1),  // gift
//            UIColor(red: 123/255, green: 175/255, blue: 127/255, alpha: 1), // goals
            UIColor(red: 242/255, green: 235/255, blue: 191/255, alpha: 1), // roller
            UIColor(red: 178/255, green: 215/255, blue: 223/255, alpha: 1), // shirt
            UIColor(red: 136/255, green: 152/255, blue: 126/255, alpha: 1), // shoe
            UIColor(red: 108/255, green: 189/255, blue: 190/255, alpha: 1), // travel
        ]
        
        static let mainColor = UIColor(red: 49/255, green: 59/255, blue: 65/255, alpha: 1) // main
    }
    
}
