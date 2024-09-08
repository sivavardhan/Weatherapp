//
//  ResultCitiesModel.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

struct ResultCitiesModel: Codable,Hashable {
    let totalResultsCount: Int
    let geonames: [City]
}

// City model
struct City: Codable,Hashable {
    let name: String

}
