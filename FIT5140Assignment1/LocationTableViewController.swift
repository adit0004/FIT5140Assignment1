//
//  LocationTableViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 30/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    var listenerType: ListenerType = ListenerType.locations
    
    var locationList:[Location] = []
    var filteredLocations:[Location] = []
    var mapViewController:MapViewController?
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Do any additional setup after loading the view.
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for locations"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onLocationsChange(change: DatabaseChange, locations: [Location]) {
        locationList = locations
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        let locationObj = locationList[indexPath.row]
        let location:LocationAnnotation = LocationAnnotation(newTitle: locationObj.locationName!, newSubtitle: locationObj.locationDescription!, latitude: locationObj.latitude, longitude: locationObj.longitude, category: locationObj.locationCategory!)
        locationCell.locationNameLabel.text = location.title
        locationCell.locationDescriptionLabel.text = location.subtitle
        
        // Try checking if a named xcasset exists
        var imageToSet:UIImage? = UIImage(named: locationObj.imagePathOrName!)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
