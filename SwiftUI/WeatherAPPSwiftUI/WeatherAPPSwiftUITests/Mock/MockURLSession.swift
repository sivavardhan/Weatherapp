//
//  MockURLSession.swift
//  WeatherAPPTests
//
//  Created by siva reddy on 9/7/24.
//

import Foundation
@testable import WeatherAPPSwiftUI

class MockURLSession:URLSessionProtocol
{
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
      func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            if let error = error {
                throw error
            }
            guard let data = data, let response = response else {
                throw APIError.invalidResponse
            }
            return (data, response)
        }
}


