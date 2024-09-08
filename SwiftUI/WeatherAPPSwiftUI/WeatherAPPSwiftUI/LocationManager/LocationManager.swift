//
//  LocationManager.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

/*
 This class primary responsblity is fetch the current location using Core Location framework and fetching the City name from Location Object
 Once fetch the City Name it will notify the view model object
 */
import Foundation
import CoreLocation

class LocationManager:NSObject,CLLocationManagerDelegate
{
    let manager = CLLocationManager()
    @Published var cityName = ""
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // request for Location update through Autorization
    func requestLocation()
    {
        manager.desiredAccuracy = kCLLocationAccuracyBest // setiing Accuracy for best
        manager.requestWhenInUseAuthorization() // requesting for Autorization
    }
    
    // Stops the location updates once we recived the current City Name
    func stopLocationUpdates()
    {
        manager.stopUpdatingLocation() // calling Stop method of Location Manager, so that we won't get any updates even if Location changes also
    }

}

extension LocationManager
{
    // MARK: - CLLocation Delegate Methods
    // This delegate Method will give location details, then will pass Location object to Fetch City Name
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCityName(from: location) // Sending Location object for fetching location
    }
    
    // Will Invoke this method for failure of acessing Locaton
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        debugPrint("Unable to access Location with Error \(error.localizedDescription)") // Printing Error
    }
    

    // Will Invoke this method when the authorization status changes for this application
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways: //will fall in this case, If User Accepts to allow fetch location through this app
            manager.startUpdatingLocation() // Starting Location updates
        case .denied, .restricted: //will fall in this case,If User denied or restricted to allow fetch location through this app
            print("Location access denied or restricted.")
            // Handle accordingly, maybe show an alert or fallback to manual input
        case .notDetermined: // Not clicked
            manager.requestWhenInUseAuthorization() // requesting for Autorization
        @unknown default:
            break
        }
    }
    
    
    // This Method Fetch Name from Location Object
    func fetchCityName(from location: CLLocation) {
        let geocoder = CLGeocoder() // Creating Geocoder object. This object will use for forward geocode and reverse geocode
        
        // Using reverse geocode methods for fetching CityName
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                // Getting Error for reverse Geocoding
                debugPrint("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }
            // Checking for Placemark Object as a first Object
            if let placemark = placemarks?.first {
                DispatchQueue.main.async { // geting Main Quee for updating City Name
                    if let cityName =  placemark.locality { // getting City Name
                        
                        self?.cityName = cityName // Assigninf to cityName Publisher
                        self?.stopLocationUpdates() // Stoping the Location update
                    }
                }
            }
        }
    }
    

    
}

