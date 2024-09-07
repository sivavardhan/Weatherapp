# Weather Display and city Search App

## Overview

This iOS application allows users to search for weather information by city name in the US and display the current weather conditions. The app is built using Swift UIKit and follows the MVVM (Model-View-ViewModel) architecture pattern.

## Features

- Search for weather by city name.
- Display current weather conditions including temperature, weather status, and icons.
- Efficiently manage network requests and handle caching.
- Asynchronous data fetching and UI updates.

## Architecture

The app is designed using the MVVM-C architecture:

- **Model**: Represents the data structure for weather information and city search results.
- **View**: Manages the user interface and displays weather data.
- **ViewModel**: Handles the business logic, processes user input, and updates the view with the latest data.
- **Coordinator** Handles The Navigation logic, bettween the screens


## Project Structure

- **Model**: Contains data structures such as 'WeatherObj', 'ResultCitiesModel'
- **ViewModel**: Includes classes like 'WeatherViewModel' and 'SearchCityViewModel' that handle data fetching, processing, and provide data to the views.
- **View**: Consists of view controllers and UI components that present the data to the user.

## Unit Testing
- Validated Response of Weather data with Dummy data
- Validated Response of Cities data with Dummy data
- Validated iamge Caching mechanisim with dummy image


# Known issues
- Error Handling Not updating to UI, Just Printing on Cosole. Due to time Constarins not able to finish. If get time will finish that also
