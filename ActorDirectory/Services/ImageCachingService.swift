//
//  ImageCachingService.swift
//  ActorDirectory
//
//  Created by Nadia Barbosa on 12/15/20.
//

import UIKit
import Foundation

/**
 The `ImageCachingService` handles the loading and caching
 of images at the specified URL.
 */
class ImageCachingService {
    /**
     Relying on a singleton shared instance
     as to not end up with multiple caches.
     */
    static let shared = ImageCachingService()

    var cache = NSCache<NSString, UIImage>()

    func loadImage(for url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {

        /**
         Since it is noted that images will have unique URLs, the url
         itself is used to uniquely identify the image in the cache.
         */
        if let existingCachedImage = cache.object(forKey: NSString(string: url.absoluteString)) {
            completion(.success(existingCachedImage))
            return
        } else {
            /**
             If a cached image isn't found at the given url, request a new image
             and save it to the cache.
             */
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: NSString(string: url.absoluteString))
                        completion(.success(image))
                        return
                    }
                }
            }.resume()
        }
    }
}

