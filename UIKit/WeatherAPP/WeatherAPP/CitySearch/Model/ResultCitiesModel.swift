//
//  ResultCitiesModel.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

struct ResultCitiesModel: Codable {
//    let totalResultsCount: Int
    let geonames: [City]
}

// City model
struct City: Codable {
    let name: String

}
