//
//  LocationTableViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 30/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController, UISearchResultsUpdating {
    var listenerType: ListenerType = ListenerType.locations
    var locationList:[Location] = []
    var filteredLocations:[Location] = []
    var mapViewController:MapViewController?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Set filteredLocations to have contents of locationList initially
        filteredLocations = locationList
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for locations"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Assign mapViewController to the mapView variable from appDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mapViewController = appDelegate.mapView
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.count > 0 {
            filteredLocations = locationList.filter({(location: Location) -> Bool in
                return (location.locationName?.contains(searchText))!
            })
        }
        else {
            filteredLocations = locationList;
        }
        
        tableView.reloadData();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredLocations.count
        }
        return locationList.count
    }
    
    // Private function to check if filter is active
    
    // Followed tutorial from here: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    func isFiltering() -> Bool {
        return !(searchController.isActive && (searchController.searchBar.text?.isEmpty ?? true))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        print(isFiltering())
        let location:Location
        if isFiltering() {
            location = filteredLocations[indexPath.row]
        }
        else {
            location = locationList[indexPath.row]
        }
        
        locationCell.locationNameLabel.text = location.locationName
        locationCell.locationDescriptionLabel.text = location.locationDescription
        
        // Try checking if a named xcasset exists
        var imageToSet:UIImage? = UIImage(named: location.imagePathOrName!)
        // If xcasset is nil, try fetching content of file
        if (imageToSet == nil) {
            // TODO: fetch from file
            imageToSet = UIImage(named: "Placeholder")
        }
        
        locationCell.locationImageField.image = imageToSet
        
        return locationCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mapViewController?.locationsDeleted.append(filteredLocations[indexPath.row])
            self.filteredLocations.remove(at:indexPath.row)
            self.locationList.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locationList[indexPath.row]
        
        // Remove this view, go back to where we came from (would be mapViewController, unless I messed up real bad)
        self.navigationController!.popViewController(animated: true)
        
        // Set the lat, long to focus on mapViewController
        mapViewController?.latToZoomOn = location.latitude
        mapViewController?.longToZoomOn = location.longitude
    }
}
