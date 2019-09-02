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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let searchController = UISearchController(searchResultsController: nil)
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
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredLocations = locationList.filter({(location: Location) -> Bool in
                return (location.locationName?.lowercased().contains(searchText))!
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
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        let location = locationList[indexPath.row]
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
            self.locationList.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create annotation before trying to focus on it?
        let location = locationList[indexPath.row]
        print("Click happened")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let navigationView = appDelegate.navigationView
        navigationView?.popViewController(animated: true)
        mapViewController?.latToZoomOn = location.latitude
        mapViewController?.longToZoomOn = location.longitude
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
