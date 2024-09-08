//
//  WeatherView.swift
//  WeatherAPPSwiftUI
//
//  Created by siva reddy on 9/7/24.
//

import SwiftUI

struct WeatherView: View {
    
    var weather: WeatherObj
    
    var body: some View {
        
            VStack(alignment: .leading)
            {

                VStack(alignment: .leading, spacing: 5)
                {
                    Text(weather.name) // Updating City Name
                        .bold()
                        .font(.title)
                        .padding(.top)
                    
                    Text("Today \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
               
                VStack(spacing: 8)
                {
                    HStack
                    {
                        VStack (spacing: 8)
                        {
                            // downloading Icon from openweather.org
                            AsyncImage(url: URL(string: Constatns.weatcherIconsBaseUrl+weather.weather[0].icon+"@2x.png")) { image in
                                image
//                                    .font(.system(size: 20))
                                    .frame(width: 40, height: 50)

                            } placeholder: {
                                ProgressView()
                            }
                            Text(weather.weather[0].main) // Updating Weather Status
                        }
                        Spacer()
                        // updating Temprature
                        Text("Feels Like: " + weather.main.feelsLike.roundDouble()+"°F")
                            .font(.system(size: 25))
                            .bold()
                            .padding()
                    }
                    .padding(.horizontal,16)

                    HStack{
                      Text("Max: " + weather.main.tempMax.roundDouble() + "°F")
                        Spacer()
                      Text("Min: " + weather.main.tempMin.roundDouble() + "°F")
                    }
                    .font(.system(size: 25))
                    .padding(.horizontal,16)

//                        .frame(height: 80)
                    // updating City Image
                    Image("cityImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350)
                        
                        .padding(.horizontal)
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        

        }
    }

#Preview {
    WeatherView(weather: weatherDummyData)
}
