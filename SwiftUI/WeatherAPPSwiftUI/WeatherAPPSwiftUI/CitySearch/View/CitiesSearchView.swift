//
//  CitiesSearchView.swift
//  WeatherAPPSwiftUI
//
//  Created by siva reddy on 9/7/24.
//

import SwiftUI

struct CitiesSearchView: View {
    @StateObject var searchViewModel = SearchCityViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack
        {
            if let citiesObj = searchViewModel.searchedResults
            {
                List // Showing in List of Results
                {
                    ForEach(citiesObj.geonames,id: \.self)
                    { cityObj in
                        Text(cityObj.name) // Displying City Name
                            .onTapGesture {
                                //Once Selected, updtaing City Name
                                searchViewModel.selectedCity(cityObj: cityObj)
                                // Navigating Back to View
                                self.popToViewController()
                            }
                    }
                }
                
            }
            else if searchViewModel.serachedQuery.count >= 1
            {
                ProgressView() // Showing Progress view for asynchronous call
            }
        }
            .searchable(text: $searchViewModel.serachedQuery)
            .onChange(of: searchViewModel.serachedQuery) { _, newValue in
                
                if newValue.isEmpty
                {
                    // Clearing Search Results if clicked cancel or cleared search text filed
                    searchViewModel.clearSearchResults()
                }
            }
    }
    
    func popToViewController()
    {
        // Navigating to Back screen
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    CitiesSearchView()
}
