//
//  SearchCityViewModel.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//


import Foundation
import Combine

class SearchCityViewModel:ObservableObject
{
    @Published var serachedQuery: String = ""
    @Published var searchedResults: ResultCitiesModel?
    
    private var cancellabels = Set<AnyCancellable>() // A set to store Combine's AnyCancellable instances, ensuring subscriptions are retained and can be cancelled when no longer needed.
    private let apiClient: CitiesAPIClientProtocol

    init(apiClient: CitiesAPIClientProtocol = CitiesAPIClient()) {
        // Initialize the apiClient property with the provided apiClient argument.
        // If no argument is provided, it defaults to an instance of CitiesAPIClient.

        self.apiClient = apiClient
        // Call the bindingSearchQuery method to set up any necessary bindings or observers
        // related to the search query.

        bindingSearchQuery()
    }
    
    func bindingSearchQuery() {
        // Bind to the $serachedQuery property, which is presumably a @Published property in a Combine-based ViewModel.
        // Apply a debounce to wait for 300 milliseconds after the last input before proceeding.
        // This helps reduce unnecessary API calls while the user is typing.
        // Remove consecutive duplicate queries to avoid redundant search operations.
        // CompactMap transforms the search query, encoding it for use in a URL, and filters out
        // The sink operator handles the encoded search query.
        
        $serachedQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap{$0.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)}
            .sink { [weak self] quey in
                if quey.count > 1
                {
                    // Call the performSearch method with the sanitized query string.
                    self?.performSearch(query: quey)
                }
            }
            .store(in: &cancellabels) // Store the resulting Combine pipeline in the cancellables set to manage memory and lifecycle.
        
    }
     func performSearch(query: String)
    {
        // Construct the URL string for the city search API call.
        // It combines the base URL, the search query, and any necessary URL suffixes or parameters.
        let urlStr = Constatns.citySearchEndURL + query + Constatns.citiesSearchEndURL
        // Execute the search operation asynchronously in a new task.
        Task
        {
            do {
                // Attempt to fetch the list of cities matching the search query.

                if let citiesObj = try await apiClient.fetchCitieesList(with: urlStr)
                {
                    // If the fetch is successful, update the searchedResults property with the returned city data.

                    self.searchedResults = citiesObj
                }
            } catch  {
                // If an error occurs during the fetch, print the error's localized description for debugging.
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}
