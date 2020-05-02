//
//  Wish.swift
//  ShareExtension
//
//  Created by Christian Konnerth on 01.05.20.
//  Copyright © 2020 CKBusiness. All rights reserved.
//

import Foundation
import UIKit

struct Wish: Codable {
    public var name: String
    public var checkedStatus: Bool
    public var link: String
    public var price: String
    public var note: String
    public var image: UIImage

    init(name: String, link: String, price: String, note: String, image: UIImage, checkedStatus: Bool) {
        self.name = name
        self.checkedStatus = checkedStatus
        self.link = link
        self.price = price
        self.note = note
        self.image = image
    }

    enum CodingKeys: String, CodingKey {
        case name, checkedStatus, link, price, note, image
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        checkedStatus = try values.decode(Bool.self, forKey: .checkedStatus)
        link = try values.decode(String.self, forKey: .link)
        price = try values.decode(String.self, forKey: .price)
        note = try values.decode(String.self, forKey: .note)

        let data = try values.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: data) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: values, debugDescription: "Invalid image data")
        }
        self.image = image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(checkedStatus, forKey: .checkedStatus)
        try container.encode(link, forKey: .link)
        try container.encode(price, forKey: .price)
        try container.encode(note, forKey: .note)
        try container.encode(image.pngData(), forKey: .image)
    }
}
