//
//  WishlistStruct.swift
//  Wishlist
//
//  Created by Christian Konnerth on 30.12.19.
//  Copyright © 2019 CKBusiness. All rights reserved.
//

import UIKit

struct Wishlist: Codable {
    var name: String
    var image: UIImage
    var wishes: [Wish]
    var color: UIColor
    var textColor: UIColor
    var index: Int

    enum CodingKeys: String, CodingKey {
        case name, image, wishData, color, textColor, index
    }

    init(name: String, image: UIImage, wishes: [Wish], color: UIColor, textColor: UIColor, index: Int) {
        self.name = name
        self.image = image
        self.wishes = wishes
        self.color = color
        self.textColor = textColor
        self.index = index
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        wishes = try values.decode([Wish].self, forKey: .wishData)
        color = try values.decode(Color.self, forKey: .color).uiColor
        textColor = try values.decode(Color.self, forKey: .textColor).uiColor
        index = try values.decode(Int.self, forKey: .index)

        let data = try values.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: data) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: values, debugDescription: "Invalid image data")
        }
        self.image = image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(wishes, forKey: .wishData)
        try container.encode(Color(uiColor: color), forKey: .color)
        try container.encode(Color(uiColor: textColor), forKey: .textColor)
        try container.encode(index, forKey: .index)
        try container.encode(image.pngData(), forKey: .image)
    }
}
