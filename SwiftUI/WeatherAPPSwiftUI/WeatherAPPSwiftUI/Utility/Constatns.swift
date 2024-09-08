//
//  Constatns.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

struct Constatns {
    
    // Weather Base URL String for openweathermap.org.
    static let weatherSearchBaseUrl = "https://api.openweathermap.org/data/2.5/weather?q="
    
    // API Key for openweathermap.org
    static let apiKeyForOpenWeather = "5432bf106a12f17470b0a26fb17c5319"
    // Weather status Icon image URL String
    static let weatcherIconsBaseUrl = "https://openweathermap.org/img/wn/"
    
    // http://api.geonames.org/searchJSON?q=New&country=US&maxRows=10&username=sivavardhan458
    
    // Fetching Cities Base URL String for api.geonames.org.
    static let citySearchEndURL = "http://api.geonames.org/searchJSON?q="
    // Fetching Cities End URL String
    static let citiesSearchEndURL = "&country=US&maxRows=10&username=\(geoNamesUSerName)"
    // Fetching Cities userName value
    static let geoNamesUSerName = "sivavardhan458"
}
