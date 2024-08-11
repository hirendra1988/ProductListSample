//
//  ProductsViewModel.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

protocol ProductDetailsViewProtocol: ProductProtocol {
    func reloadData()
}

class ProductDetailsViewModel {
    weak var delegate: ProductDetailsViewProtocol?
    private var networkProtocol: NetworkManagerProtocol
    private var parser: ParsingResponse
    var productId: String = ""

    var productDetailsModel: ProductDetailsModel? {
        willSet {
            self.delegate?.reloadData()
        }
    }

    init(networkProtocol: NetworkManagerProtocol = NetworkManager(),
         parser: ParsingResponse = ParsingResponse(), productId: String) {
        self.networkProtocol = networkProtocol
        self.parser = parser
        self.productId = productId
    }

    func getProductsDetails() {
        if !ReachabilityManager.shared.isConnected {
            self.delegate?.addErrorView(message: ProductStrings.ErrorMessage.noInternetConnection)
            return
        }
        let url = ProductStrings.baseURL + String(format: ProductStrings.EndPoint.productDetails, self.productId)
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
        let parsedData = self.parser.parse(data: data, type: ProductDetailsModel.self)
        switch parsedData {
        case .success(let productDetailsModel):
            self.productDetailsModel = productDetailsModel
            self.delegate?.hideIndicator()
        case .failure:
            self.delegate?.addErrorView(message: ProductStrings.ErrorMessage.apiFailedError)
        }
    }

}
