//
//  ContentView.swift
//  WeatherAPPSwiftUI
//
//  Created by siva reddy on 9/7/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    
    @State var isPresenting: Bool = false
    
    var body: some View {
        NavigationStack
        {
            VStack(alignment:.leading) {
                if let weatherCurrent = weatherViewModel.weatherObject {
                    VStack(spacing: 20) {
                        WeatherView(weather: weatherCurrent)
                        
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                }
                else
                {
                    
                    Text("Somthing wrong") // Displaying message if not recived any object
                    ProgressView() // Showing Progress view for asynchronous call
                }
            }
            .navigationTitle("Weather")
            .onAppear(perform: {
                // On Apperaing Screen reloading data if required
                weatherViewModel.refreshWeatherInfoIfRequired()
            })
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CitiesSearchView() // Clicking Search button Action
                    } label: {
                        // Adding Image for Search button Icon
                        Image(systemName: "magnifyingglass")
                            .font(.headline)
                            .bold()
                    }
                }
            }
        }
        .alert(isPresented: $isPresenting, content: {
            // Configure the alert
            Alert(
                title: Text("Alert Title"),
                message: Text("This is the alert message."),
                dismissButton: .default(Text("OK"))
            )

        })
    }
}

#Preview {
    ContentView()
}
