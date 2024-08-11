//
//  NetworkManager.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func performRequest(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {

    func performRequest(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            }
        }.resume()

    }

}
