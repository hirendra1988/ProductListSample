//
//  ProductStrings.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

enum ProductStrings {

    static var baseURL = "https://api.target.com/"

    enum ProductList {
        static var screenName = "List"
        static var regText = "reg."
        static var inAisle = "in aisle"
    }

    enum ProductDetail {
        static var screenName = "Detail"
        static var productDetails = "Product details"
        static var addToCart = "Add to cart"
    }

    enum EndPoint {
        static var productList = "mobile_case_study_deals/v1/deals"
        static var productDetails = "\(productList)/%@"
    }

    enum ErrorMessage {
        static var apiFailedError = "Something went wrong. Please try again."
        static var noInternetConnection = "No Internet Connection. Please try again."
    }

}
