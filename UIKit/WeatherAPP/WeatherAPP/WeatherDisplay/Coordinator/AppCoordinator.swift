//
//  AppCoordinator.swift
//  WeatherAppForCities
//
//  Created by siva reddy on 9/6/24.
//

import UIKit

class AppCoordinator:Coordinator
{
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    
    func start() {
        showWeatherScreen()
    }
    
    func showWeatherScreen(){
        
        let weatherVM = WeatherViewModel()
        let weatherVC = WeatherViewController()
        weatherVC.viewModel = weatherVM
        weatherVC.onCitySearchTapped = { [weak self] in
            self?.startCitySearchCoordinator()
        }
        self.navigationController.pushViewController(weatherVC, animated: true)
        
    }
    func startCitySearchCoordinator(){
        let citiesSearchCoordinator = CitySearchCoordinator(navigationController: self.navigationController)
        addChildCoordinator(citiesSearchCoordinator)
        citiesSearchCoordinator.onCitySelected = { [weak self] in
            self?.removeChildCoordinator(citiesSearchCoordinator)
        }
        citiesSearchCoordinator.start()
    }
}
