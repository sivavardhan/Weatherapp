//
//  ImageDownloader.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

/*
 This calss will help to download images from Server based on URL
 
 */
import UIKit

class ImageDownloader {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // Method to download image asynchronously
    func downloadImage(from urlString: String) async throws -> UIImage? {
        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            // Return the cached image if it exists
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            // Throwing Error for Invalid URL
            throw APIError.invalidURL
        }
        // getting data and response from Server using async and await
        let (data, response) = try await self.session.data(for: URLRequest(url: url))
        
        // Check if the response is valid and has a status code of 200
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            
            // Throwing Error as Invalid Response
            throw APIError.invalidResponse
        }
        
        // Creating Image from recived Data from cloud
        guard let image = UIImage(data: data) else {
            // Throwing Error for decoding error
            throw APIError.decodingError(URLError(.cannotDecodeContentData))
        }
        
        // Cache the downloaded image
        ImageCacheManager.shared.cacheImage(image, forKey: urlString)
        
        // return the Image
        return image
    }
}
