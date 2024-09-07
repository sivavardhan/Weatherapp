//
//  ImageDownloaderTests.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import XCTest
@testable import WeatherAPP

final class ImageDownloaderTests: XCTestCase {
    var imageDownloader: ImageDownloader!
    var mockURLSession: MockURLSession!
    var mockCacheManager: MockImageCacheManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockURLSession = MockURLSession()
        imageDownloader = ImageDownloader(session:mockURLSession)
        mockCacheManager = MockImageCacheManager()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        imageDownloader = nil
        mockURLSession = nil
        mockCacheManager = nil
        super.tearDown()

    }
    
//    func testDownloadImageFromNetworkSuccess() async throws {
//            // Given
//            let imageURLString = "https://example.com/image.png"
//            let expectedImage = UIImage(systemName: "star")!
//            let imageData = expectedImage.pngData()!
//
//            // Set up the mock URL session
//            mockURLSession.data = imageData
//            mockURLSession.response = HTTPURLResponse(url: URL(string: imageURLString)!,
//                                                      statusCode: 200,
//                                                      httpVersion: nil,
//                                                      headerFields: nil)
//
//            // Set up the cache manager
//            ImageCacheManager.shared = mockCacheManager
//
//            // When
//            let image = try await imageDownloader.downloadImage(from: imageURLString)
//
//            // Then
//            XCTAssertNotNil(image)
//            XCTAssertEqual(image, expectedImage)
//            XCTAssertEqual(mockCacheManager.cachedImages[imageURLString], expectedImage)
//        }
        
        func testDownloadImageFromCache() async throws {
            // Given
            let imageURLString = "https://example.com/image.png"
            let cachedImage = UIImage(systemName: "star")!
            
            // Add the image to the cache
            mockCacheManager.cachedImages[imageURLString] = cachedImage
            ImageCacheManager.shared = mockCacheManager
            
            // When
            let image = try await imageDownloader.downloadImage(from: imageURLString)
            
            // Then
            XCTAssertNotNil(image)
            XCTAssertEqual(image, cachedImage)
        }
        
        func testDownloadImageFailure() async throws {
            // Given
            let imageURLString = "https://example.com/image.png"
            
            // Set up the mock URL session to simulate a network error
            mockURLSession.error = URLError(.badServerResponse)
            
            // When & Then
            do {
                _ = try await imageDownloader.downloadImage(from: imageURLString)
                XCTFail("Expected error to be thrown")
            } catch {
                XCTAssertNotNil(error)
            }
        }


}
