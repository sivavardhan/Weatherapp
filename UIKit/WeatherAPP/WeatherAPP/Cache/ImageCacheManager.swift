//
//  ImageCacheManager.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

/*
 This manager calss will help to cahce images.
 If Image not saved earlier it will save now
 If image is already saved, will return Image from Cache Object
 */
import Foundation

import UIKit

class ImageCacheManager {
    
    // Singleton instance
    static var shared = ImageCacheManager()
    
    // NSCache to store images
    private let imageCache = NSCache<NSString, UIImage>()
    
     init() {
        // Set any desired cache limits, like total cost or item count
        imageCache.countLimit = 100 // Maximum number of images in cache
        imageCache.totalCostLimit = 50 * 1024 * 1024 // Maximum memory in bytes (50 MB)
       
    }
    
    // Method to cache an image
    func cacheImage(_ image: UIImage, forKey key: String) {
        let cost = image.pngData()?.count ?? 0
        imageCache.setObject(image, forKey: key as NSString, cost: cost)
    }
    
    // Method to retrieve an image from cache
    func getImage(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    // Method to remove an image from cache
    func removeImage(forKey key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }
    
    // Method to clear the cache
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
