//
//  DropDownStruct.swift
//  Wishlists
//
//  Created by Christian Konnerth on 30.03.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import UIKit

struct DropDownOption: Codable {
    public var name: String
    public var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }

    enum CodingKeys: String, CodingKey {
        case name, checkedStatus, link, price, note, image
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)

        let data = try values.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: data) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: values, debugDescription: "Invalid image data")
        }
        self.image = image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(image.pngData(), forKey: .image)
    }
}

