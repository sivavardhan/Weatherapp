//
//  MockImageCacheManager.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import Foundation
import Foundation
import UIKit
@testable import WeatherAPPSwiftUI

class MockImageCacheManager: ImageCacheManager {
    var cachedImages = [String: UIImage]()

    override func getImage(forKey key: String) -> UIImage? {
        return cachedImages[key]
    }

    override func cacheImage(_ image: UIImage, forKey key: String) {
        cachedImages[key] = image
    }
}
