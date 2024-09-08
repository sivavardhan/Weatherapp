//
//  CitiesAPIFetchingTest.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import XCTest
@testable import WeatherAPPSwiftUI

final class CitiesAPIFetchingTest: XCTestCase {

    func testFetchWeatherSuccess() async throws {
        // Given
        let mockSession = MockURLSession() // Creating Mock session
        let apiClient = CitiesAPIClient(session: mockSession) // Injecting Mock Session
        let urlString = "https://api.weather.com"
        // Mock response
        mockSession.data = CitiesMockData.citiesJSONData // Creating Mock data
        
        // Creating Mock response
        mockSession.response = HTTPURLResponse(url: URL(string: urlString)!,
                                               statusCode: 200, httpVersion: nil, headerFields: nil)

        // When
        let citiesResult = try await apiClient.fetchCitieesList(with: "Seattle")

        // Then
        XCTAssertEqual(citiesResult?.geonames[0].name, "Seattle")
    }
    func testFetchWeatherFailure() async {
        // Given
        let mockSession = MockURLSession()// Creating Mock session
        let apiClient = CitiesAPIClient(session: mockSession)// Injecting Mock Session
        let urlString = "https://api.weather.com"
        // Mock response
        mockSession.data = nil // setting data nil, for error senarios
        
        
        // Creating Mock response with Error
        mockSession.response = HTTPURLResponse(url: URL(string: urlString)!,
                                               statusCode: 500, httpVersion: nil, headerFields: nil)

        // When
        do {
            _ = try await apiClient.fetchCitieesList(with: "Seattle")
            XCTFail("Expected failure but got success")
        } catch {
            // Then
            XCTAssertNotNil(error)
        }
    }

}
