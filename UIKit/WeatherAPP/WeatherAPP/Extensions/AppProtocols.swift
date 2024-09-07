//
//  AppProtocols.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

/*
 This file having all Protocolos used in this application
 These Protocols are using for Dependency Injection for more testable and more reusable code
 */
import Foundation

protocol URLSessionProtocol {
    // For Data Task for accepting URLRequest
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol WeatherAPIClientProtocol {
    // This method for weather Fectching for Particular City
    func fetchCityWeather(with city: String) async throws -> WeatherObj
}

protocol CitiesAPIClientProtocol {
    // This method for Fectch cities based on search string
    func fetchCitieesList(with searchString: String) async throws -> ResultCitiesModel?
}

protocol APIClientProtocol {
    
    associatedtype Element
    // This method for weather Fectching for Particular City
    func fetchDetailsFromServer(with urlString: String) async throws -> Element
}
