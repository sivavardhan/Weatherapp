//
//  Coordinator.swift
//  WeatherAppForCities
//
//  Created by siva reddy on 9/6/24.
//

import UIKit

protocol Coordinator : AnyObject
{
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}


extension Coordinator
{
    func addChildCoordinator(_ coordinator: Coordinator)
    {
        childCoordinators.append(coordinator)
    }
    func removeChildCoordinator(_ coordinator: Coordinator)
    {
        childCoordinators = childCoordinators.filter{$0 !== coordinator}

    }

}
