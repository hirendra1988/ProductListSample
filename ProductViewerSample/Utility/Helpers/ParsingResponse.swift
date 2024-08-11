//
//  ResponseManager.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation

class ParsingResponse {

    func parse<T: Decodable>(data: Data, type: T.Type) -> Result<T, Error> {
        do {
            let decodableData = try JSONDecoder().decode(type, from: data)
            return .success(decodableData)
        } catch {
            return .failure(error)
        }
    }

}
