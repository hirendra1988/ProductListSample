//
//  ImageLoadOperation.swift

//
//  Created by Hirendra Sharma on 10/08/24.
//

import UIKit

class ImageLoadOperation: Operation {

    var imageURL: String

    init(url: String) {
        self.imageURL = url
    }

    func downloadImage(completion: @escaping(UIImage?) -> Void) {
        if let cachedImage = CommonFunctions.shared.imageCache.image(forKey: imageURL) {
            completion(cachedImage)
            return
        }
        if isCancelled {
            completion(nil)
            return
        }

        guard let url = URL(string: imageURL) else {
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                return
            }
            if let imageData = data {
                if let image = UIImage(data: imageData) {
                    if self.isCancelled {
                        completion(image)
                        return
                    }
                    CommonFunctions.shared.imageCache.setImage(image, forKey: self.imageURL)
                    DispatchQueue.main.async { [weak self] in
                        guard self != nil else {
                            return
                        }
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
