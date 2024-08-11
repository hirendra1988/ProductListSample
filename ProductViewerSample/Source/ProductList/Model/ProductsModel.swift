//
//  ProductsModel.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

// MARK: - ProductsModel
struct ProductsModel: Codable {
    let products: [Product]?
}

// MARK: - Product
struct Product: Codable, Hashable {
    let id: Int?
    let title, aisle, description: String?
    let imageURL: String?
    let regularPrice: Price?
    let fulfillment: Fulfillment?
    let availability: Availability?
    let salePrice: Price?

    enum CodingKeys: String, CodingKey {
        case id, title, aisle, description
        case imageURL = "image_url"
        case regularPrice = "regular_price"
        case fulfillment, availability
        case salePrice = "sale_price"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title
    }
}

enum Availability: String, Codable {
    case inStock = "In stock"
}

enum Fulfillment: String, Codable {
    case online = "Online"
}

// MARK: - Price
struct Price: Codable {
    let amountInCents: Int?
    let currencySymbol: CurrencySymbol?
    let displayString: String?

    enum CodingKeys: String, CodingKey {
        case amountInCents = "amount_in_cents"
        case currencySymbol = "currency_symbol"
        case displayString = "display_string"
    }
}

enum CurrencySymbol: String, Codable {
    case empty = "$"
}
