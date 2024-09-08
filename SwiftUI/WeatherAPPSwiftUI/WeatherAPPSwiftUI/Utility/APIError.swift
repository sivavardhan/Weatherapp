//
//  APIError.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case unknownError
    case dataNotFound
    

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server response was invalid."
        case .decodingError(let error):
            return "Failed to decode the data: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .unknownError:
            return "An unknown error occurred."
        case .dataNotFound:
            return "Data not found (404)."
        }
    }
}
