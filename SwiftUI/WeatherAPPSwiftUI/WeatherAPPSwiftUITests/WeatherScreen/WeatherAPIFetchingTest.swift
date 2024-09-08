//
//  WeatherAPIFetchingTest.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import XCTest
@testable import WeatherAPPSwiftUI

final class WeatherAPIFetchingTest: XCTestCase {

    func testFetchWeatherSuccess() async throws {
        // Given
        let mockSession = MockURLSession()// Creating Mock session
        let apiClient = WeatherAPIClient(session: mockSession)
        let urlString = "https://api.weather.com"
        // Mock response
        mockSession.data = WeatherMockData.weatherJSONData// Creating Mock data
        
        // Creating Mock response
        mockSession.response = HTTPURLResponse(url: URL(string: urlString)!,
                                               statusCode: 200, httpVersion: nil, headerFields: nil)

        // When
        let weatherObj = try await apiClient.fetchCityWeather(with: urlString)

        // Then
        XCTAssertEqual(weatherObj.name, "Seattle")
        XCTAssertEqual(weatherObj.sys.country, "US")
    }
    func testFetchWeatherFailure() async {
        // Given
        let mockSession = MockURLSession()// Creating Dummy session
        let apiClient = WeatherAPIClient(session: mockSession)
        let urlString = "https://api.weather.com"
        // Mock response
        mockSession.data = nil // setting data nil, for error senarios
        
        // Creating Mock response with Error
        mockSession.response = HTTPURLResponse(url: URL(string: urlString)!,
                                               statusCode: 500, httpVersion: nil, headerFields: nil)

        // When
        do {
            _ = try await apiClient.fetchCityWeather(with: urlString)
            XCTFail("Expected failure but got success")
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }

}
