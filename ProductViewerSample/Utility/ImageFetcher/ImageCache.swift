//
//  ImageCache.swift
//  ProductViewerSample
//
//  Created by Hirendra Sharma on 10/08/24.
//

import Foundation
import UIKit

final class ImageCache {
    private let cache = NSCache<AnyObject, UIImage>()

    init(countLimit: Int = 100, totalCostLimit: Int = 50 * 1024 * 1024) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    func setImage(_ image: UIImage, forKey key: String) {
        let cost = image.jpegData(compressionQuality: 1.0)?.count ?? 0
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func removeAllImages() {
        cache.removeAllObjects()
    }
}
