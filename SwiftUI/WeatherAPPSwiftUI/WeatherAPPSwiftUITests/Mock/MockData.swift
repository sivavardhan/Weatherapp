//
//  MockData.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import Foundation
@testable import WeatherAPPSwiftUI

struct WeatherMockData {
    static let weatherJSONData = getPlainDataFromFile("MockWeatherData.json").data(using: .utf8)!
}
struct CitiesMockData {
    static let citiesJSONData = getPlainDataFromFile("MockCitiesData.json").data(using: .utf8)!
}
