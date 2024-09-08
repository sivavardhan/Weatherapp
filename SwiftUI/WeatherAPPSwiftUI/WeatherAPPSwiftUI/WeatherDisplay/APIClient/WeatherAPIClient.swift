//
//  WeatherAPIClient.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation
/*
 This class responsibility for
 1. Fetching Weather Data from openweathermap.org based on CityName
 
 */

class WeatherAPIClient: WeatherAPIClientProtocol {
    private let session: URLSessionProtocol // Creating Session Object
    
    init(session: URLSessionProtocol = URLSession.shared) { // Initializing Session Object with Defaults. It will useful for inject Dependency
        self.session = session // assigning session object whether with Default value or Injected Value
    }
    
    // Fetch Weather for selected City
    func fetchCityWeather(with urlString: String) async throws -> WeatherObj {
        guard let url = URL(string: urlString) else { // creating URL Object, if it fails throwing error
            throw APIError.invalidURL // Throwing Error for Invalid URL
        }
        
        // getting data and response from Server using async and await
        let (data, response) = try await session.data(for: URLRequest(url: url))
        
        // Check if the response is valid and has a status code between 200 to 299 and 404
        
        if let httpResponse = response as? HTTPURLResponse // Safely cast the response as an HTTPURLResponse to access the status code
        {
            switch httpResponse.statusCode {
            case 200...299:
                // If the status code is in the 200-299 range, it's considered a successful response
                break
            case 404:
                // If the status code is 404, it means "Data Not Found", so we throw the appropriate APIError
                throw APIError.dataNotFound
            default:
                // For any other status codes, we throw a general server error, passing the status code for debugging

                throw APIError.serverError(httpResponse.statusCode)
            }
        }

        let decoder = JSONDecoder() // Creating Json Decoder Object
        do {
            decoder.keyDecodingStrategy = .convertFromSnakeCase // decoder stargey
            let weather = try decoder.decode(WeatherObj.self, from: data) // Decoding the Weather object from Server response data
            return weather // returns Weather Obj
        } catch {
            throw APIError.decodingError(error) //Throwing Error for parsing Decode error
        }
    }
}
