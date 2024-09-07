//
//  CitiesSearchViewModelTest.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import XCTest
@testable import WeatherAPP
final class CitiesSearchViewModelTest: XCTestCase {
    
    func testViewModelFetchWeatherSuccess() async throws {
        // Given
        let mockAPIClient = MockCitiesSearchAPIClient()
        let viewModel = SearchCityViewModel(apiClient: mockAPIClient) // Injecting Mock API Client
        mockAPIClient.citiesResult = citiesDummyData //Creating a Cities Dummy Object and loading dummy values
        
        // When
         viewModel.performSearch(query: "Seattle")
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        
        // Then
        XCTAssertEqual(viewModel.searchedResults?.geonames[0].name, "Seattle")
    }


}
