//
//  Extensions.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

/*
 This Files having the Extensions for this Application
 */
import Foundation

// Extension for Double
extension Double
{
    // round the Double and returns string for update UI
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}


extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request, delegate: nil)
    }
}
