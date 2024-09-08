//
//  WeatherViewModel.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import Foundation
import Combine
import UIKit

@MainActor
class WeatherViewModel: ObservableObject {
    
    private var cityName: String = "" // for City Name
     var errorMessage: String? // Store Error Mesage
    @Published var isPageNotFound: Bool?
    
    @Published var weatherObject:WeatherObj? // Store Weather Details for City and it is Publisher will send the values over the time
    
    private var cancellable = Set<AnyCancellable>() // A set to store Combine's AnyCancellable instances, ensuring subscriptions are retained and can be cancelled when no longer needed.
    
    private let apiClient: WeatherAPIClientProtocol // Creating API Client Object
    private let locationManager = LocationManager() // Creating Location Object
    
    init(apiClient: WeatherAPIClientProtocol = WeatherAPIClient()) { // Initializing API Client Object with Defaults. It will useful for inject Dependency
        self.apiClient = apiClient // assigning api client object whether with Default value or Injected Value
        fetchSavedCity() // Checking City Details save or not, if not there fetching Cureent Location
    }
    
    // Checking whther city name saved or not, if Saved fetching weather information based on City Name.
    // If not saved city name, Calling Locatoion Manager class to fetch the cureent city information
    func fetchSavedCity()
    {
        if let cityName = PersistanceManager.shared.getCityName() // Fetching from User defaults
        {
            print("City Name Saved in Storage")
        }
        else
        {
            // Calling location manager to fetch current Location
            self.locationManager.requestLocation()
            
            // Subscribing the CityName Value Publisher
            locationManager.$cityName
                .receive(on: RunLoop.main)// Recive Values on Main Thread
                .sink { completion in // Subcriber for omited Values completion notication
                    debugPrint("Value Recived")
                } receiveValue: { cityName in // Subcriber will recive the City Name
                    if cityName.count > 1 {
                        Task
                        {
                            self.cityName = cityName // assigning The City Name
                            PersistanceManager.shared.setCityName(self.cityName) // Strore into User Defaults
                            await self.fetchWeather(for:cityName) // fetch Weather for City
                        }
                    }
                   
                }
                .store(in: &cancellable) // Store the resulting Combine pipeline in the cancellables set to manage memory and lifecycle.
        }
    }
    func fetchWeather(for city: String) async {
        // Ensure the city name is not empty. If it is, set an error message and return.
        guard !city.isEmpty else {
            await MainActor.run {
                self.errorMessage = "City name cannot be empty."
            }
            
            return
        }
        // Construct the URL string for the weather API using the base URL, city name, and API key.
        let urlStr = "\(Constatns.weatherSearchBaseUrl)\(city)&appid=\(Constatns.apiKeyForOpenWeather)&units=imperial"
        // Reset the error message before making the API call.

        await MainActor.run {
            self.errorMessage = nil
        }

        

        do {
            // Attempt to fetch the weather data for the specified city using the API client.
            self.weatherObject = try await apiClient.fetchCityWeather(with: urlStr)
            
        } catch let error as APIError {
            // If the error is an APIError, set the error message to the error description.
//            self.errorMessage = error.errorDescription
            switch error {
            case .dataNotFound:
                self.isPageNotFound = true
                print("Display 404 error")
                print(error.errorDescription ?? "")
            default:
                print(error.errorDescription ?? "")
                break
            }
        } catch {
            // If any other error occurs, set a generic error message and log the error.
            await MainActor.run {
                self.errorMessage = "An unexpected error occurred."
            }
            print("An unexpected error occurred.")
        }

    }
    
    // Reload weather data from server if Required
    func refreshWeatherInfoIfRequired()
    {
        // Check if there's a saved city name in the persistence storage.
        if let savedCityName = PersistanceManager.shared.getCityName()
        {
            // Compare the saved city name with the current city name.
            if cityName != savedCityName {
                // If they are different, update the current city name with the saved one.
                self.cityName = savedCityName
                
                // Asynchronously fetch the weather information for the updated city name.
                Task
                {
                    
                    await self.fetchWeather(for:self.cityName)
                }
            }
        }
    }
}

extension WeatherViewModel
{
    func fetchIconForWeatherStatus(for iconName: String) async throws -> UIImage
    {
        // Construct the URL string for the weather icon using the base URL, icon name, and image format.
        // Example URL format: "https://example.com/icons/10d@2x.png"
        let urlString = Constatns.weatcherIconsBaseUrl + iconName + "@2x.png"
        do {
            // Attempt to download the image using the ImageDownloader class.
            // The method is awaited because it is asynchronous.

            guard let image = try await ImageDownloader().downloadImage(from: urlString) else
            {
                throw APIError.invalidResponse
            }
            // Return the downloaded image.

            return image
        } catch  {
            // If any other error occurs during the image download, throw an unknown error.

            throw APIError.unknownError
        }
    }
}
