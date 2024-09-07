//
//  WeatherViewController.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    
    
    var onCitySearchTapped: (() -> Void)?

    
    var cityNameLbl = UILabel() // For Display Name of the City
    
    
    var dateLbl = UILabel() // For Display today Date
    var maximumLbl = UILabel() // For Display Maximum temp
    var minimumLbl = UILabel() // For Display Minimum temp
    var weatherIconImageview = UIImageView() // For weather Image Icon for status changes i.e. clouds, rain, clear Icons etc...
    var weatherStatus = UILabel() // For weather status changes i.e. clouds, rain, clear etc...
    var fellsLikeLbl = UILabel() // Displaying Temparature
    var cityImageView = UIImageView() // For Selected City Image. For now it's Static Image only
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large) // Craeting loading Indicator to show while fetching weather data
    
    var viewModel:WeatherViewModel? // Creating Viewmodel Object
    private var cancellable = Set<AnyCancellable>() // A set to store Combine's AnyCancellable instances, ensuring subscriptions are retained and can be cancelled when no longer needed.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createUIElements()
        addSearchBarButtonItem() // adding Search Bar button
        bindValues() // Binding Values from ViewModel Class for updating View
        addActivityIndicator() // adding Activity Indicator to View
        self.view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Weather Details" // Updating Title
        viewModel?.refreshWeatherInfoIfRequired() // Refreshing Weather Data if Required
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = "" // Updating Title to Empty
    }
    func addSearchBarButtonItem()
    {
        // Create a search button using the system search icon
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        // Set the search button as the right bar button item in the navigation bar
        navigationItem.rightBarButtonItem = searchButton
    }
    // Action triggered when the search button is tapped
    @objc func searchButtonTapped() {
        // calling closure for coordinator
        onCitySearchTapped?()
    }
}

extension WeatherViewController
{
    // Hiding all UI Elements
    func hideUIElements()
    {
        self.cityNameLbl.isHidden = true
        self.dateLbl.isHidden = true
        self.weatherIconImageview.isHidden = true
        self.weatherStatus.isHidden = true
        self.fellsLikeLbl.isHidden = true
        self.cityImageView.isHidden = true
        self.maximumLbl.isHidden = true
        self.minimumLbl.isHidden = true
        self.loadingIndicator.isHidden = false

    }
    // Showing all UI Elements
    func showUIElements(){
        self.cityNameLbl.isHidden = false
        self.dateLbl.isHidden = false
        self.weatherIconImageview.isHidden = false
        self.weatherStatus.isHidden = false
        self.fellsLikeLbl.isHidden = false
        self.cityImageView.isHidden = false
        self.maximumLbl.isHidden = false
        self.minimumLbl.isHidden = false
        self.loadingIndicator.isHidden = true
    }
    func bindValues(){
        
        // Subscribing the weather Object Publisher
        viewModel?.$weatherObject
            .receive(on: DispatchQueue.main) // Recive Values on Main Thread
            .sink { [weak self] _ in // Subcriber for omited Values from View controller class. Using [weak self] for handling crash and memory management
                self?.updateUIElements() // Updating UI after reciving value
            }
            .store(in: &cancellable) // Store the resulting Combine pipeline in the cancellables set to manage memory and lifecycle..
        
        viewModel?.$isPageNotFound
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {  [weak self] _ in
                self?.showErrorAlert(withMessage: "The Specified Weather data Not found, Please select another City from Search")
            })
            .store(in: &cancellable)
        
        
    }
    func updateUIElements(){
        if let weatherObj = viewModel?.weatherObject
        {
            self.showUIElements() // Displaying all UI Elements and updating values

            self.cityNameLbl.text = weatherObj.name // Updatng City Name
            self.dateLbl.text = Date().formatted(.dateTime.month().day().hour().minute()) // Updatng current Date
            Task // Creating Asynchronous environment
            {
                // Fetching Icon with Caching mechanism
                self.weatherIconImageview.image =  try? await viewModel?.fetchIconForWeatherStatus(for: weatherObj.weather[0].icon)
            }
            self.weatherStatus.text = weatherObj.weather[0].main // Updatng Weather Status
            self.fellsLikeLbl.text = "Feels Like: " + weatherObj.main.feelsLike.roundDouble()+"°F" // Updatng temparature
            self.maximumLbl.text = "Max: " + weatherObj.main.tempMax.roundDouble() + "°F"
            self.minimumLbl.text = "Min: " + weatherObj.main.tempMin.roundDouble() + "°F"
        }
    }
}
extension WeatherViewController
{
    func addActivityIndicator()
    {
        // Configure the loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        // Center the loading indicator in the view
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }

}


extension WeatherViewController
{
    func createUIElements() {
        self.cityNameLbl.font = UIFont.boldSystemFont(ofSize: 30.0)
        self.cityNameLbl.text = "City Name"
        self.dateLbl.text = "City Name"
        
        self.cityNameLbl.isAccessibilityElement = true
        self.cityNameLbl.accessibilityHint = "Dispalying City Information"
        self.cityNameLbl.accessibilityLabel = "City Name is Dallas"
        
        
        self.dateLbl.font = UIFont.systemFont(ofSize: 17.0)
        let verticalStackView = UIStackView(arrangedSubviews: [self.cityNameLbl, self.dateLbl])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .leading
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.weatherIconImageview = UIImageView(image: UIImage(systemName: "cloud.sun.rain"))
        self.weatherIconImageview.contentMode = .scaleAspectFill
        self.weatherIconImageview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.weatherIconImageview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.weatherIconImageview.isAccessibilityElement = true
//        self.weatherIconImageview.accessibilityHint = "Weather Status ICON"
//        self.weatherIconImageview.accessibilityTraits = .image
        
        self.weatherStatus.font = UIFont.systemFont(ofSize: 17.0)
        self.weatherStatus.text = "Cloudydfghhfgh"
        
        let weatherStatusStackView = UIStackView(arrangedSubviews: [self.weatherIconImageview,self.weatherStatus])
        self.weatherStatus.heightAnchor.constraint(equalToConstant: 20).isActive = true
        weatherStatusStackView.axis = .vertical
        weatherStatusStackView.spacing = 8
        weatherStatusStackView.alignment = .leading
        weatherStatusStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.fellsLikeLbl.font = UIFont.systemFont(ofSize: 30.0)
        self.fellsLikeLbl.text = "299"
        let weatherStatusStackView1 = UIStackView(arrangedSubviews: [weatherStatusStackView,self.fellsLikeLbl])
        weatherStatusStackView1.axis = .horizontal
        weatherStatusStackView1.spacing = 8
        weatherStatusStackView1.alignment = .leading
        weatherStatusStackView1.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to the main view
        self.view.addSubview(verticalStackView)
        // Add views to the main view
        self.view.addSubview(verticalStackView)
        self.view.addSubview(weatherStatusStackView1)
        
        self.cityImageView.image = UIImage(named: "image.jpg")
        self.cityImageView.contentMode = .scaleToFill
        self.cityImageView.translatesAutoresizingMaskIntoConstraints = false
        self.cityImageView.isAccessibilityElement = true
        
        self.view.addSubview(self.cityImageView)
        
        // Vertical stack constraints
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])

        NSLayoutConstraint.activate([
            weatherStatusStackView1.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor,constant: 20),
            weatherStatusStackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherStatusStackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        

        self.maximumLbl.font = UIFont.systemFont(ofSize: 25)
        self.minimumLbl.font = UIFont.systemFont(ofSize: 25)
        
        let maxAndMinStackView = UIStackView(arrangedSubviews: [self.maximumLbl,self.minimumLbl])
        maxAndMinStackView.axis = .horizontal
        maxAndMinStackView.spacing = 8
        maxAndMinStackView.alignment = .leading
        maxAndMinStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(maxAndMinStackView)
        NSLayoutConstraint.activate([
            maxAndMinStackView.topAnchor.constraint(equalTo: weatherStatusStackView1.bottomAnchor,constant: 20),
            maxAndMinStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            maxAndMinStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            self.cityImageView.topAnchor.constraint(equalTo: maxAndMinStackView.bottomAnchor, constant: 20),
            self.cityImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            self.cityImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            self.cityImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
        ])
        

        
        hideUIElements() // Hiding all UI Elements until fetch the weather Data

    }
    func showErrorAlert(withMessage message:String)
    {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)

    }

}
