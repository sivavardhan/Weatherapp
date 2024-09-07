//
//  WeatherSearchViewModelTest.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import XCTest
@testable import WeatherAPP
final class WeatherSearchViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testViewModelFetchWeatherSuccess() async throws {
        // Given
        let mockAPIClient = MockWeatherAPIClient()
        let viewModel = WeatherViewModel(apiClient: mockAPIClient) // Injecting Mock API Client
        mockAPIClient.weatherToReturn = weatherDummyData  //Creating a Wather Dummy Object and loading dummy values
        
        // When
        await viewModel.fetchWeather(for: "Seattle")
        
        // Then
        XCTAssertEqual(viewModel.weatherObject?.name, "Seattle")
        XCTAssertEqual(viewModel.weatherObject?.main.feelsLike, 298.74)
    }


}
