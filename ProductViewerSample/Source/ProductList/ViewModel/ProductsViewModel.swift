//
//  ProductsViewModel.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

protocol ProductProtocol: NSObject {
    func showIndicator()
    func hideIndicator()
    func addErrorView(message: String)
    func removeErrorView()
}

protocol ProductListViewProtocol: ProductProtocol {
    func reloadData()
}

enum ProductSection {
    case main
}

class ProductsViewModel {

    weak var delegate: ProductListViewProtocol?
    private var networkProtocol: NetworkManagerProtocol
    private var parser: ParsingResponse
    let imagePrefetcher: ImagePrefetcher = {
        let imageFetcher = ImagePrefetcher()
        return imageFetcher
    }()

    var productsModel: ProductsModel? {
        willSet {
            self.delegate?.reloadData()
        }
    }

    init(networkProtocol: NetworkManagerProtocol = NetworkManager(),
         parser: ParsingResponse = ParsingResponse()) {
        self.networkProtocol = networkProtocol
        self.parser = parser
    }

    func getProductsList() {
        if !ReachabilityManager.shared.isConnected {
            self.delegate?.addErrorView(message: ProductStrings.ErrorMessage.noInternetConnection)
            return
        }
        let url = ProductStrings.baseURL + ProductStrings.EndPoint.productList
        self.delegate?.showIndicator()
        self.networkProtocol.performRequest(urlStr: url) { response in
            switch response {
            case .success(let data):
                self.parsingResponse(data: data)
            case .failure:
                self.delegate?.addErrorView(message: ProductStrings.ErrorMessage.apiFailedError)
            }
        }
    }

    func parsingResponse(data: Data) {
        let parsedData = self.parser.parse(data: data, type: ProductsModel.self)
        switch parsedData {
        case .success(let productsModel):
            self.productsModel = productsModel
            self.delegate?.hideIndicator()
        case .failure:
            self.delegate?.addErrorView(message: ProductStrings.ErrorMessage.apiFailedError)
        }
    }

}
