//
//  ProductDetailsModel.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

// MARK: - ProductDetailsModel
struct ProductDetailsModel: Codable, Hashable {
    let id: Int?
    let title, aisle, description: String?
    let imageURL: String?
    let regularPrice, salePrice: Price?
    let fulfillment, availability: String?

    enum CodingKeys: String, CodingKey {
        case id, title, aisle, description
        case imageURL = "image_url"
        case regularPrice = "regular_price"
        case salePrice = "sale_price"
        case fulfillment, availability
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }

    static func == (lhs: ProductDetailsModel, rhs: ProductDetailsModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title
    }
}
