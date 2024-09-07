//
//  WeatherModelData.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation
var weatherDummyData: WeatherObj = loadData("MockWeatherData.json") // Weather Dummy Data from JSON
var citiesDummyData: ResultCitiesModel = loadData("MockCitiesData.json") // Cities Dummy Data from JSON

func loadData<T: Decodable>(_ filename: String) -> T {
    let data: Data
    // Attempt to get the URL of the file in the main bundle using the provided filename.
    // If the file is not found, terminate the application with a fatal error.

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        // Attempt to load the data from the file URL.
        // If loading fails, terminate the application with a fatal error.

        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        // Create a JSONDecoder instance to decode the JSON data.
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Attempt to decode the data into the specified type T.
        // If decoding fails, terminate the application with a fatal error.

        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
func getPlainDataFromFile(_ fileName: String) -> String
{
    var resultString = ""
    // Attempt to get the URL of the file in the main bundle using the provided filename.
    // If the file is not found, terminate the application with a fatal error.
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil)
        else {
            fatalError("Couldn't find \(fileName) in main bundle.")
    }

    do {
        
        // Attempt to load the plan text from the file URL.
        // If loading fails, terminate the application with a fatal error.

        resultString = try String(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(fileName) from main bundle:\n\(error)")
    }
    return resultString
}

