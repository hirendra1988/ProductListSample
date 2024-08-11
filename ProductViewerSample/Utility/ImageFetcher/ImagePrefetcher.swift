//
//  ImagePrefetcher.swift
//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class ImagePrefetcher {
    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        return queue
    }()

    private var operations = [String: ImageLoadOperation]()

    func prefetchImages(for urls: [String]) {
        for urlStr in urls {
            guard operations[urlStr] == nil else { continue }
            let operation = ImageLoadOperation(url: urlStr)
            operations[urlStr] = operation
            operationQueue.addOperation(operation)
        }
    }

    func cancelPrefetching(for urls: [String]) {
        for url in urls {
            operations[url]?.cancel()
            operations.removeValue(forKey: url)
        }
    }

    func loadImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = CommonFunctions.shared.imageCache.image(forKey: url) {
            completion(cachedImage)
            return
        }

        let operation = ImageLoadOperation(url: url)
        operation.downloadImage { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
        operations[url] = operation
        operationQueue.addOperation(operation)
    }
}
