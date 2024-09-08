////
////  CitySearchCoordinator.swift
////  WeatherAppForCities
////
////  Created by siva reddy on 9/6/24.
////
//
//import UIKit
//
//class CitySearchCoordinator:Coordinator
//{
//    var navigationController: UINavigationController
//    
//    var childCoordinators: [Coordinator] = []
//    
//    var onCitySelected: (() -> Void)?
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start() {
//        showCitySearchScreen()
//    }
//    
//    func showCitySearchScreen()
//    {
//        
//        let citiesSearchVM = SearchCityViewModel()
//        let citiesSearchScreen = CitiesSearchVC()
//        citiesSearchScreen.viewModel = citiesSearchVM
//        citiesSearchScreen.onCitySelected = { [weak self] in
//            self?.onCitySelected?()
//            self?.navigationController.popViewController(animated: true)
//        }
//        self.navigationController.pushViewController(citiesSearchScreen, animated: true)
//        
//    }
//    
//}
