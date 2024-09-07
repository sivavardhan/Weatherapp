//
//  PersistanceManager.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

// Creating the singleton class for UserDefault Manager class for saving City Name and retrival City
final class PersistanceManager
{
    // Key for City Name
    private let cityNameKey = "cityNamekey"
    
    // Shared Object with statis
    static let shared = PersistanceManager()
    
    // Initilaztion with Private, to make sure don't initilaztion from ouside
    private init() {}
    
    // Save the city name
    func setCityName(_ name: String) {
        UserDefaults.standard.set(name, forKey: cityNameKey)
    }
    
    // Retrieve the city name
    func getCityName() -> String? {
        return UserDefaults.standard.string(forKey: cityNameKey)
    }
    
    // Clear the city name
    func clearCityName() {
        UserDefaults.standard.removeObject(forKey: cityNameKey)
    }
}
