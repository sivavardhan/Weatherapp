//
//  WeatherObj.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

// MARK: - WeatherLocal
struct WeatherObj: Codable {
    let weather: [Weather]
    let main: MainWeather
    let sys: Sys
    let id: Int
    let name: String
    
}

// MARK: - Main
struct MainWeather: Codable {
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    enum CodingKeys: String, CodingKey {
        case feelsLike
        case tempMin
        case tempMax
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

