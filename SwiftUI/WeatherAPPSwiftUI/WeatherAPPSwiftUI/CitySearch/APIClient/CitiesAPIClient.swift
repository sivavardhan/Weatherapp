//
//  CitiesAPIClient.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation

/*
 This class responsibility for
 1. Fetching Cities List from api.geonames.org based on Searchtext
 
 */
class CitiesAPIClient: CitiesAPIClientProtocol
{
    private let session: URLSessionProtocol // Creating Session Object
    
    init(session: URLSessionProtocol = URLSession.shared) { // Initializing Session Object with Defaults. It will useful for inject Dependency
        self.session = session // assigning session object whether with Default value or Injected Value
    }

    // Fetch Cities based on Search value
    func fetchCitieesList(with searchString: String) async throws -> ResultCitiesModel? {
        
        guard let url = URL(string: searchString) else // creating URL Object, if it fails throwing error
        {
            
            throw APIError.invalidURL // Throwing Error for Invalid URL
        }
        do{
            // getting data and response from Server using async and await
            let (data,respone) = try await session.data(for: URLRequest(url: url))
            
            do {
                return try handleResponseData(data: data, response: respone, expectingType: ResultCitiesModel.self)
            } catch  {
                throw APIError.invalidResponse // Throwing Error for invalid server response
            }
        }
        catch
        {
            throw APIError.networkError(error)
        }
        

    }
    func handleResponseData(data: Data?, response: URLResponse?, expectingType: ResultCitiesModel.Type) throws -> ResultCitiesModel?
    {
        // Check if the response is valid and has a status code between 200 to 299
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else
        {
            debugPrint("Error while Downloading")
            throw APIError.serverError((response as? HTTPURLResponse)?.statusCode ?? 0) // Throwing Error for invalid server response
        }
        
        do
        {
            let jsonDecoder = JSONDecoder() // decoder stargey
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase //decoder stargey
            let response = try jsonDecoder.decode(ResultCitiesModel.self, from: data) // Decoding the Cities object from Server response data
            return response // returns Cities Object
        }
        catch
        {
            debugPrint("The Parsing Error is \(error.localizedDescription)")
            throw APIError.decodingError(error) //Throwing Error for parsing Decode error
            
        }
    }
    
}
