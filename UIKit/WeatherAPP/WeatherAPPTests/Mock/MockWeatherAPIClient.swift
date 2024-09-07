//
//  MockWeatherAPIClient.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

import Foundation
@testable import WeatherAPP

// Mock Weather API Client for ViewModel Testing
class MockWeatherAPIClient: WeatherAPIClientProtocol {
    
    var weatherToReturn: WeatherObj?
    var errorToReturn: Error?
    func fetchCityWeather(with city: String) async throws -> WeatherObj {
        if let error = errorToReturn {
            throw error
        }
        if let weather = weatherToReturn {
            return weather
        }
        throw APIError.invalidResponse
    }
}

class MockCitiesSearchAPIClient: CitiesAPIClientProtocol
{
    var citiesResult: ResultCitiesModel?
    var errorToReturn: Error?

    func fetchCitieesList(with searchString: String) async throws -> ResultCitiesModel? {
        if let error = errorToReturn {
            throw error
        }
        if let cities = citiesResult {
            return cities
        }
        throw APIError.invalidResponse
    }
    
    
}
