//
//  CitiesSearchVC.swift
//  WeatherAPP
//
//  Created by siva reddy on 9/7/24.
//

import UIKit
import Combine

class CitiesSearchVC: UIViewController {

    private var searchbar = UISearchBar() // SearchBar Creation
    private var resultTableView = UITableView() // Creating TableView
    var viewModel:SearchCityViewModel? // Creating View Model Object
    private var cancellable = Set<AnyCancellable>() // A set to store Combine's AnyCancellable instances, ensuring subscriptions are retained and can be cancelled when no longer needed.
    
    var onCitySelected: (() -> Void)?
    private let loadingIndicator = UIActivityIndicatorView(style: .large) // Craeting loading Indicator to show while fetching weather data
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView() // Set up TableView
        setUpSearchBar() // Set Up Search Bar
        bindValues() // Call the bindingvalues method to set up any necessary bindings or observers

        addActivityIndicator() // adding Activity indicator to View
        self.view.backgroundColor = .white
    }
    
    private func setUpSearchBar()
    {
        searchbar.delegate = self
        searchbar.placeholder = "Searching.." // default Value in search bar
        navigationItem.titleView = searchbar // setting it to navigation title View as Search Bar
    }
    private func setUpTableView() {
        resultTableView.dataSource = self // Tableview Data Source owning
        resultTableView.delegate = self// Tableview Delegate owning
        
        self.view.addSubview(self.resultTableView) //Adding Tableview to View
        resultTableView.translatesAutoresizingMaskIntoConstraints = false // Setting False to Activae Constarints
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Registering Cell with tableview Object
        NSLayoutConstraint.activate([ // Activating Constrains for TableViw
            resultTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // Top Anchor with view safe area top
            resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), // Bottom Anchor with view safe area bottom
            resultTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor), // Rightside Anchor with view safe area rightside
            resultTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor) // Leftside Anchor with view safe area leftside
        ])
    }
    func bindValues(){
        // Bind to the viewModel's @Published searchedResults property.
        // Any changes to searchedResults will trigger the following pipeline.
        // Ensure that the subsequent operations are performed on the main thread.
        // This is important because UI updates must happen on the main thread.
        // The sink operator captures any new value of searchedResults.
        // It updates the UI by hiding the loading indicator and reloading the table view data.

        viewModel?.$searchedResults.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                // Hide the loading indicator once the search results are received.
                self?.loadingIndicator.isHidden = true
                
                // Reload the table view with the new search results.
                self?.resultTableView.reloadData()
            }
            .store(in: &cancellable)// Store the resulting Combine pipeline in the cancellables set to manage memory and lifecycle.
    }

}

extension CitiesSearchVC: UISearchBarDelegate
{
    
    // MARK: - SearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
   {
       if searchText.isEmpty {
           // The cross mark (clear button) was clicked
           // Handle the clear button click event here
           viewModel?.searchedResults = nil
           
       }
       else
       {
           // Hide the loading indicator once the search results are received.
           self.loadingIndicator.isHidden = false
           
           // Update the view model's searchedQuery property with the new search text. this will triger the Subcriber
           viewModel?.serachedQuery = searchText
       }
   }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchedResults = nil
    }
}

extension CitiesSearchVC: UITableViewDataSource
{
    // MARK: - TablewView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchedResults?.geonames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a reusable cell from the table view using the identifier "cell".
        // This creates or reuses a cell for the given index path.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
        if let citiesObj = viewModel?.searchedResults
        {
            // Access the specific city object for the current row.
            let cityObj = citiesObj.geonames[indexPath.row]
            
            // Set the text of the cell's text label to the name of the city
            cell.textLabel?.text = cityObj.name
        }
        return cell // returns the cell Object
    }
}

extension CitiesSearchVC :UITableViewDelegate
{
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let citiesObj = viewModel?.searchedResults
        {
            // Access the specific city object for the current row.
            let cityObj = citiesObj.geonames[indexPath.row]
            // saving city Name into User defaults
            PersistanceManager.shared.setCityName(cityObj.name)
            
            // Navigating Back to previous view Controller
            popToViewController()
        }
    }
    func popToViewController()
    {
        
        onCitySelected?()
        // Navigating Back to previous view Controller
//        self.navigationController?.popViewController(animated: true)
    }
}

extension CitiesSearchVC
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
